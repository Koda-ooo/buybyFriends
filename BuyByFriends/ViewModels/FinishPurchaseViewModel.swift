//
//  FinishPurchaseViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/18.
//

import Foundation
import Combine
import SwiftUI

final class FinishPurchaseViewModel: ViewModelObject {
    final class Input: InputObject {
        //シェア系
        let startToShareToInstagramStory = PassthroughSubject<Data, Never>()
        let startToShareToTwitter = PassthroughSubject<Void, Never>()
        let startToShareToLine = PassthroughSubject<Void, Never>()
        
        //遷移系
        let startToMoveTopView = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: BindingObject {
        // 遷移系
        @Published var isMovedTopView = false
    }
    
    final class Output: OutputObject {
    }
    
    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false
    private let shareProvider: ShareProviderProtocol
    
    
    init(shareProvider: ShareProviderProtocol = ShareProvider()) {
        self.shareProvider = shareProvider
        
        let input = Input()
        let binding = Binding()
        let output = Output()
        
        /// ホーム画面へ遷移
        let isMovedTopView = input.startToMoveTopView
            .flatMap {
                Just(true)
            }
        
        ///Instagram
        input.startToShareToInstagramStory
            .flatMap { data in
                shareProvider.shareToInstagramStory(imageData: data)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { result in
                print(result)
            }
            .store(in: &cancellables)
        
        ///Twitter
        input.startToShareToTwitter
            .flatMap {
                shareProvider.shareOnTwitter()
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { result in
                print(result)
            }
            .store(in: &cancellables)
        
        ///LINE
        input.startToShareToLine
            .flatMap {
                shareProvider.shareOnLINE()
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            } receiveValue: { result in
                print(result)
            }
            .store(in: &cancellables)
        
        /// 組み立てたストリームを反映
        cancellables.formUnion([
            isMovedTopView.assign(to: \.isMovedTopView, on: binding)
        ])
        
        self.input = input
        self.binding = binding
        self.output = output
    }
    
    func convertURLToData(url: String) {
            guard let url = URL(string: url) else {
                print("エラー")
                return
            }
            do {
                let data = try Data(contentsOf: url)
                input.startToShareToInstagramStory.send(data)
            } catch {
                print("エラー")
            }
        }
}
