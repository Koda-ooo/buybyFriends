//
//  MessageViewModel.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import MessageKit
import PhotosUI

final class MessageViewModel: ViewModelObject {

    final class Input: InputObject {
        let startToObserveMessages = PassthroughSubject<Void, Never>()
        let startToFetchPartnerUserInfo = PassthroughSubject<String, Never>()
        let startToShowPHPicker = PassthroughSubject<Void, Never>()
        let startToCreateTextMessage = PassthroughSubject<String, Never>()
        let startToCreateImageMessage = PassthroughSubject<UIImage, Never>()
        let startToShowImageViewer = PassthroughSubject<UIImage, Never>()
    }

    final class Binding: BindingObject {
        @Published var chatRoomID: String = ""
        @Published var text: String = ""
        @Published var sender: UserInfo = UserInfo(dic: [:])
        @Published var messages: [ChatMessage] = []

        @Published var isShownPHPicker: Bool = false
        @Published var isShownImageViewer: Bool = false
    }

    final class Output: OutputObject {
        @Published fileprivate(set) var partner: UserInfo = UserInfo(dic: [:])
        @Published fileprivate(set) var partnerImage: UIImage = UIImage()
        @Published fileprivate(set) var viewerImage: UIImage = UIImage()
    }

    let input: Input
    @BindableObject private(set) var binding: Binding
    let output: Output
    private var cancellables = Set<AnyCancellable>()
    @Published private var isBusy: Bool = false

    private var messageProvider: MessageProviderObject
    private var chatRoomProvider: ChatRoomProviderObject
    private var userInfoProvider: UserInfoProviderObject

    init(
        messageProvider: MessageProviderObject = MessageProvider(),
        chatRoomProvider: ChatRoomProviderObject = ChatRoomProvider(),
        userInfoProvider: UserInfoProviderObject = UserInfoProvider()
    ) {
        self.messageProvider = messageProvider
        self.chatRoomProvider = chatRoomProvider
        self.userInfoProvider = userInfoProvider

        let input = Input()
        let binding = Binding()
        let output = Output()

        input.startToObserveMessages
            .flatMap {
                messageProvider.observeMessage(
                    query: Firestore.firestore()
                        .collection("ChatRooms").document(binding.chatRoomID)
                        .collection("Messages")
                        .order(by: "createdAt", descending: false)
                )
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { result in
                let messages = result.compactMap {
                    switch $0.messageType {
                    case "text":
                        return ChatMessage.new(
                            sender: UserType(senderId: $0.senderID, displayName: $0.senderID),
                            messageId: $0.id,
                            sentDate: $0.createdAt.dateValue(),
                            message: $0.message)
                    case "image":
                        return ChatMessage.new(
                            sender: UserType(senderId: $0.senderID, displayName: $0.senderID),
                            messageId: $0.id,
                            sentDate: $0.createdAt.dateValue(),
                            url: $0.message)
                    default:
                        return nil
                    }
                }
                binding.messages = messages
            }
            .store(in: &cancellables)

        input.startToFetchPartnerUserInfo
            .flatMap { id in
                userInfoProvider.fetchUserInfo(id: id)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { userInfo in
                output.partner = userInfo

                ImageLoader().loadImage(url: URL(string: userInfo.profileImage)!) { succeeded, image in
                    if succeeded {
                        guard let image = image else { return }
                        DispatchQueue.main.async {
                            output.partnerImage = image
                        }
                    }
                }
            }
            .store(in: &cancellables)

        input.startToCreateTextMessage
            .flatMap { text in
                messageProvider.createTextMessage(chatRoomID: binding.chatRoomID, text: text)
                    .flatMap { message in
                        chatRoomProvider.updateLatestMessageID(chatRoomID: binding.chatRoomID, messageID: message.id)
                    }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { _ in
                print("done")
            }
            .store(in: &cancellables)

        input.startToCreateImageMessage
            .flatMap { image in
                messageProvider.createImageURL(image: image.jpegData(compressionQuality: 0.1)!)
                    .flatMap { imageURL in
                        messageProvider.createImageMessage(chatRoomID: binding.chatRoomID, imageURL: imageURL)
                            .flatMap { message in
                                chatRoomProvider.updateLatestMessageID(chatRoomID: binding.chatRoomID, messageID: message.id)
                            }
                    }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print(err.localizedDescription)
                case .finished:
                    print("finished")
                }
            }) { _ in
                print("done")
            }
            .store(in: &cancellables)

        input.startToShowImageViewer
            .sink { image in
                output.viewerImage = image
                binding.isShownImageViewer = true
            }
            .store(in: &cancellables)

        let isShownPHPicker = input.startToShowPHPicker
            .flatMap {
                Just(true)
            }

        // 組み立てたストリームを反映
        cancellables.formUnion([
            isShownPHPicker.assign(to: \.isShownPHPicker, on: binding)
        ])

        self.input = input
        self.binding = binding
        self.output = output
    }

    func createUIImageFromPHPikcerResult(image: PHPickerResult) {
        let itemProvider = image.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (uiImage, error) in
                if let uiImage = uiImage as? UIImage {
                    DispatchQueue.main.async {
                        self.input.startToCreateImageMessage.send(uiImage)
                    }
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
