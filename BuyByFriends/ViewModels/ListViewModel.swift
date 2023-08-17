//
//  ListViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/10.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

final class ListViewModel: ViewModelObject {
    
    final class Input: InputObject {
        let startToObserveFriendsPosts = PassthroughSubject<Void, Never>()
        let startToObserveForYouPosts = PassthroughSubject<Void, Never>()
        
        let startToCheckUserImage = PassthroughSubject<String, Never>()
        let startToFetchUserImage = PassthroughSubject<String, Never>()
        let startToCheckPostImage = PassthroughSubject<String, Never>()
        let startToFetchPostImage = PassthroughSubject<String, Never>()
    }
    
    final class Binding: BindingObject {
        // 無限カルーセル用に加工した配列
        @Published var infinityArray: [Post] = []
        // 初期位置は2に設定する
        @Published var currentIndex = 2
        // アニメーションの有無を操作
        @Published var isOffsetAnimation: Bool = false
        // アニメーション
        @Published var dragAnimation: Animation? = nil
        
        @Published var isShownPostDetail: Bool = false
        @Published var selectedPost: Post = Post(dic: [:])
        @Published var selectedIndex: String = ""
    }
    
    final class Output: OutputObject {
        @Published fileprivate(set) var friendsPosts: [Post] = []
        @Published fileprivate(set) var forYouPosts: [Post] = []
        
        @Published fileprivate(set) var userImages: Dictionary<String,Data> = [:]
        @Published fileprivate(set) var postImages: Dictionary<String,Data> = [:]
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    
    private let listProvider: ListProviderProtocol
    private let userInfoProvider: UserInfoProviderObject
    
    init(
        listProvider: ListProviderProtocol = ListProvider(),
        userInfoProvider: UserInfoProviderObject = UserInfoProvider()
    ) {
        self.listProvider = listProvider
        self.userInfoProvider = userInfoProvider
        
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        ///投稿情報取得（Friends）
        input.startToObserveFriendsPosts
            .flatMap {
                listProvider.observePosts(
                    query: Firestore.firestore()
                        .collection("Posts")
                        .limit(to: 50)
                )
            }.sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { posts in
                output.friendsPosts = posts
                output.friendsPosts.sort{ (m1, m2) -> Bool in
                    let m1Date = m1.createdAt.dateValue()
                    let m2Date = m2.createdAt.dateValue()
                    return m1Date > m2Date
                }
                binding.infinityArray = createInfinityArray(output.friendsPosts)
            }
            .store(in: &cancellables)
        
        ///投稿情報取得（ForYou）
        input.startToObserveFriendsPosts
            .flatMap {
                listProvider.observePosts(
                    query: Firestore.firestore()
                        .collection("Posts")
                        .whereField("isSold", isEqualTo: false)
                    //                      .whereField("userUID", isNotEqualTo: Auth.auth().currentUser?.uid ?? "")
                        .limit(to: 50)
                )
            }
            .sink { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            } receiveValue: { posts in
                output.forYouPosts = posts
                output.forYouPosts.sort{ (m1, m2) -> Bool in
                    let m1Date = m1.createdAt.dateValue()
                    let m2Date = m2.createdAt.dateValue()
                    return m1Date > m2Date
                }
            }
            .store(in: &cancellables)
        
        ///該当ユーザーのユーザー画像を既に取得済みか確認（ForYou）
        input.startToCheckUserImage
            .sink(receiveCompletion: { completion in
                print("receiveCompletion: \(completion)")
            }, receiveValue: { uid in
                if !(uid == "" || output.userImages.keys.contains(uid)) {
                    input.startToFetchUserImage.send(uid)
                }
            })
            .store(in: &cancellables)
        
        ///ユーザー画像取得（ForYou）
        input.startToFetchUserImage
            .flatMap { id in
                return userInfoProvider.fetchUserInfo(id: id)
                    .flatMap { value -> AnyPublisher<(imageData: Data, userInfo: UserInfo), Error> in
                        return listProvider.downloadUserImageData(userInfo: value)
                    }.eraseToAnyPublisher()
            }
            .sink (receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { result in
                output.userImages.updateValue(result.imageData, forKey: result.userInfo.id)
            }.store(in: &cancellables)
        
        ///該当投稿の画像を既に取得済みか確認
        input.startToCheckPostImage
            .sink(receiveCompletion: { completion in
                print("receiveCompletion: \(completion)")
            }, receiveValue: { imageURL in
                if !(imageURL == "" || output.postImages.keys.contains(imageURL)) {
                    input.startToFetchPostImage.send(imageURL)
                }
            })
            .store(in: &cancellables)
        
        ///投稿画像取得
        input.startToFetchPostImage
            .flatMap { imagURL in
                return listProvider.downloadPostImageData(imageURL: imagURL)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { result in
                output.postImages.updateValue(result.imageData, forKey: result.imageURL)
            }
            .store(in: &cancellables)
        
        binding.$currentIndex
            .receive(on: RunLoop.main)
            .sink { index in
                // 2要素未満の場合は、無限スクロールにしないため処理は必要なし
                if output.friendsPosts.count < 2 {
                    return
                }
                // 無限スクロールを実現させるため、オフセット移動アニメーション後（0.2s後）にcurrentIndexをリセットする
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if index <= 1 {
                        binding.currentIndex = 1 + output.friendsPosts.count
                        binding.isOffsetAnimation = false
                    } else if index >= 2 + output.friendsPosts.count {
                        binding.currentIndex = 2
                        binding.isOffsetAnimation = false
                    }
                }
            }
            .store(in: &cancellables)
        
        binding.$isOffsetAnimation
            .receive(on: RunLoop.main)
            .map { isAnimation in
                return isAnimation ? .linear(duration: 0.3) : .none
            }
            .assign(to: \.dragAnimation, on: binding)
            .store(in: &cancellables)
        
        self.input = input
        self.binding = binding
        self.output = output
        
        /// 擬似無限スクロール用の配列を生成：ex) [1,2,3]→[2,3,1,2,3,1,2]
        func createInfinityArray(_ targetArray: [Post]) -> [Post] {
            if targetArray.count > 1 {
                var result: [Post] = []
                // 最後の2要素
                result += targetArray.suffix(2)
                // 本来の配列
                result += targetArray
                // 最初の2要素
                result += targetArray.prefix(2).map { $0 }
                
                return result
            } else {
                return targetArray
            }
        }
    }
}

extension ListViewModel {
    /// itemPadding
    func carouselItemPadding() -> CGFloat {
        return 20
    }
    
    /// カルーセル各要素のWidth
    func carouselItemWidth(bodyView: GeometryProxy) -> CGFloat {
        return bodyView.size.width * 0.8
    }
    
    /// itemを中央に配置するためにカルーセルのleading paddingを返す
    func carouselLeadingPadding(index: Int, bodyView: GeometryProxy) -> CGFloat {
        return index == 0 ? bodyView.size.width * 0.1 : 0
    }
    
    /// カルーセルのOffsetのX値を返す
    func carouselOffsetX(bodyView: GeometryProxy) -> CGFloat {
        return -CGFloat(binding.currentIndex) * (bodyView.size.width * 0.8 + 20)
    }
    
    /// ドラッグ操作
    func onChangedDragGesture() {
        // ドラッグ時にはアニメーション有効
        if binding.isOffsetAnimation == false {
            binding.isOffsetAnimation = true
        }
    }
    
    /// ドラッグ操作によるcurrentIndexの操作
    func updateCurrentIndex(dragGestureValue: _ChangedGesture<GestureStateGesture<DragGesture, CGFloat>>.Value, bodyView: GeometryProxy) {
        var newIndex = binding.currentIndex
        // ドラッグ幅からページングを判定
        if abs(dragGestureValue.translation.width) > bodyView.size.width * 0.3 {
            newIndex = dragGestureValue.translation.width > 0 ? binding.currentIndex - 1 : binding.currentIndex + 1
        }
        
        // 最小ページ、最大ページを超えないようチェック
        if newIndex < 0 {
            newIndex = 0
        } else if newIndex > (binding.infinityArray.count - 1) {
            newIndex = binding.infinityArray.count - 1
        }
        
        binding.isOffsetAnimation = true
        binding.currentIndex = newIndex
    }
}
