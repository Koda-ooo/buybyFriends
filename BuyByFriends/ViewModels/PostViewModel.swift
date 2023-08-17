//
//  PostViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/30.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI

final class PostViewModel: ViewModelObject {
    
    final class Input: InputObject {
        let isSelectImagesButtonTapped = PassthroughSubject<Void, Never>()
        let isImagesSelected = PassthroughSubject<[PHPickerResult], Never>()
        let isInsertInformationButtonTapped = PassthroughSubject<PostInformation, Never>()
        let isCreatPostButtonTapped = PassthroughSubject<Void, Never>()
        let isCreatDraftButtonTapped = PassthroughSubject<Post, Never>()
    }
    
    final class Binding: BindingObject {
        @Published var images:[UIImage] = []
        @Published var explain = ""
        @Published var category = ""
        @Published var brand = ""
        @Published var size = ""
        @Published var condition = ""
        @Published var price = ""
        @Published var post = Post(dic: [:])
        
        @Published var isPHPickerShown:Bool = false
        @Published var isInsertBrandViewShown: Bool = false
        @Published var isInsertClothesSizeViewShown: Bool = false
        @Published var isInsertShoesSizeViewShown: Bool = false
        @Published var isInsertConditionViewShown: Bool = false
        @Published var isFinishPostViewShown: Bool = false
    }
    
    final class Output: OutputObject {
        @Published var intPrice: Int?
        @Published fileprivate(set) var isCreatDraftButtonEnabled = false
        @Published fileprivate(set) var isCreatPostButtonEnabled = false
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    private let postProvider: PostProviderProtocol
    
    init(postProvider: PostProvider = PostProvider()) {
        self.postProvider = postProvider
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        let isPHPickerShown = input.isSelectImagesButtonTapped
            .flatMap {
                Just(true)
            }
        
        let convertStrToInt = binding.$price.map { Int($0) }
        let stream = convertStrToInt.map {$0}
        
        ///ユーザーが選択した画像の格納処理
        input.isImagesSelected
            .flatMap { images in
                postProvider.fetchSelectedImages(images: images)
                    .catch { error -> Just<[UIImage]> in
                        print("Error:",error.localizedDescription)
                        return .init([UIImage()])
                    }
            }
            .sink { result in
                DispatchQueue.main.async {
                    for image in result {
                        binding.images.append(image)
                    }
                }
            }
            .store(in: &cancellables)
        
        input.isInsertInformationButtonTapped
            .flatMap { select in
                Just(select)
            }
            .sink { result in
                switch result {
                case .category: break
                case .brand: binding.isInsertBrandViewShown = true
                case .size:
                    if binding.category == "" {
                      break
                    } else if binding.category.hasPrefix("シューズ") {
                        binding.isInsertShoesSizeViewShown = true
                    } else {
                        binding.isInsertClothesSizeViewShown = true
                    }
                case .condition: binding.isInsertConditionViewShown = true
                case .price: break
                }
            }.store(in: &cancellables)
        
        let isImageValid = binding.$images
            .map { $0.isEmpty }
        
        let isExplainValid = binding.$explain
            .map { $0.isEmpty }
        
        let isCategoryValid = binding.$category
            .map { $0.isEmpty }
        
        let isBrandValid = binding.$brand
            .map { $0.isEmpty }
        
        let isSizeValid = binding.$size
            .map { $0.isEmpty }
        
        let isConditionValid = binding.$condition
            .map { $0.isEmpty }
        
        let isPriceValid = binding.$price
            .map { $0.isEmpty }
        
        let isCreatDraftButtonEnabled = Publishers
            .CombineLatest(
                isImageValid,
                isExplainValid
            )
            .map { $0.0 || $0.1 }
        
        let isCreatPostButtonEnabledSub = Publishers
            .CombineLatest4(
                isCategoryValid,
                isBrandValid,
                isSizeValid,
                isConditionValid
            )
            .map { $0.0 || $0.1 || $0.2 || $0.3 }
        
        let isCreatPostButtonEnabledMain = Publishers
            .CombineLatest3(
                isCreatDraftButtonEnabled,
                isCreatPostButtonEnabledSub,
                isPriceValid
            )
            .map { $0.0 || $0.1 || $0.2 }
        
        // 投稿作成処理への導線（画像保存→投稿作成）
        input.isCreatPostButtonTapped
            .flatMap {
                postProvider.createImageURL(post: binding.post, images: binding.images)
                    .flatMap(maxPublishers: .max(2)) { value -> AnyPublisher<Bool, Error> in
                        postProvider.savePostToFirestore(post: value)
                    }.eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { completion in
                print("sink(receiveCompletion: \(completion))")
            }) { value in
                //　投稿完了画面へ遷移
                binding.isFinishPostViewShown = value
            }.store(in: &cancellables)
        
        // 組み立てたストリームをbindingに反映
        cancellables.formUnion([
            isPHPickerShown.assign(to: \.isPHPickerShown, on: binding),
            stream.assign(to: \.intPrice, on: output),
            isCreatDraftButtonEnabled.assign(to: \.isCreatDraftButtonEnabled, on: output),
            isCreatPostButtonEnabledMain.assign(to: \.isCreatPostButtonEnabled, on: output)
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
}

enum PostInformation: String, CaseIterable {
    case category = "カテゴリー"
    case brand = "ブランド"
    case size = "サイズ"
    case condition = "コンディション"
    case price = "価格"
}

enum Categories: String,CaseIterable {
    case outwear = "アウター"
    case tops = "トップス"
    case bottoms = "ボトムス"
    case allin = "オールイン"
    case shoes = "シューズ"
    case accessories = "アクセサリー"
    case something = "小物"
    case others = "その他"
    
    func selectSubcategories() -> [String] {
        var subcategories: [String] = []
        
        switch self {
        case .outwear:
            for i in Categories.Outwear.allCases { subcategories.append(i.rawValue) }
            return subcategories
        case .tops:
            for i in Categories.Tops.allCases { subcategories.append(i.rawValue) }
            return subcategories
        case .bottoms:
            for i in Categories.Bottoms.allCases { subcategories.append(i.rawValue) }
            return subcategories
        case .allin:
            for i in Categories.AllIn.allCases { subcategories.append(i.rawValue) }
            return subcategories
        case .shoes:
            for i in Categories.Shoes.allCases { subcategories.append(i.rawValue) }
            return subcategories
        case .accessories:
            for i in Categories.Accessories.allCases { subcategories.append(i.rawValue) }
            return subcategories
        case .something:
            for i in Categories.Something.allCases { subcategories.append(i.rawValue) }
            return subcategories
        case .others:
            for i in Categories.Others.allCases { subcategories.append(i.rawValue) }
            return subcategories
        }
    }
    
    enum Outwear: String, CaseIterable{
        case jacket = "ジャケット"
        case coat = "コート"
        case poncho = "ポンチョ"
        case others = "その他"
    }
    
    enum Tops: String, CaseIterable {
        case tShirts = "Tシャツ"
        case poloShirts = "ポロシャツ"
        case camisole_tanktop = "キャミソール・タンクトップ"
        case longSleeveShirts = "長袖シャツ"
        case shortSleeveShirts = "半袖シャツ"
        case sweat = "スウェット"
        case sweater = "セーター"
        case cardigan = "カーディガン"
        case vest = "ベスト"
        case others = "その他"
    }
    
    enum Bottoms: String, CaseIterable {
        case jeans = "ジーンズ"
        case slacks = "スラックス"
        case shorts = "短パン"
        case chinos = "チノパン"
        case skirts = "スカート"
        case others = "その他"
    }
    
    enum AllIn: String, CaseIterable {
        case overalls = "オーバーオール"
        case matchingCloth = "セットアップ"
        case dress = "ワンピース"
        case others = "その他"
    }
    
    enum Shoes: String, CaseIterable {
        case sneakers = "スニーカー"
        case boots = "ブーツ"
        case dressShoes = "ドレスシューズ"
        case others = "その他"
    }
    
    
    enum Accessories: String, CaseIterable {
        case bracelet = "ブレスレット"
        case necklace = "ネックレス"
        case ring = "リング"
        case earrings = "ピアス・イヤリング"
        case others = "その他"
    }
    
    enum Something: String, CaseIterable {
        case bag = "バック"
        case wallet = "財布"
        case hat = "帽子"
        case sunglasses_glasses = "サングラス・メガネ"
        case watch = "時計"
        case others = "その他"
    }
    
    enum Others: String, CaseIterable {
        case others = "その他"
    }
}
