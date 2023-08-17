//
//  MessageSwiftUIVC.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import SwiftUI
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import FirebaseAuth
import PhotosUI
import Nuke
import Agrume

// MARK: - MessageSwiftUIVC

final class MessageSwiftUIVC: MessagesViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Because SwiftUI wont automatically make our controller the first responder, we need to do it on viewDidAppear
        becomeFirstResponder()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
}

// MARK: - MessagesUIView
struct MessagesUIView: UIViewControllerRepresentable {
    // MARK: Internal
    final class Coordinator {
        // MARK: Lifecycle
        init(vm: MessageViewModel) {
            self.vm = vm
        }
        
        // MARK: Internal
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.calendar = Calendar(identifier: .japanese)
            return formatter
        }()
        
        var vm: MessageViewModel
    }
    
    @StateObject var vm: MessageViewModel
    
    func makeUIViewController(context: Context) -> MessagesViewController {
        let messagesVC = MessageSwiftUIVC()
        let layout = messagesVC.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let clipBarButtonItem = InputBarButtonItem()
        
        messagesVC.messagesCollectionView.messagesDisplayDelegate = context.coordinator
        messagesVC.messagesCollectionView.messagesLayoutDelegate = context.coordinator
        messagesVC.messagesCollectionView.messagesDataSource = context.coordinator
        messagesVC.messagesCollectionView.messageCellDelegate = context.coordinator
        messagesVC.messageInputBar.delegate = context.coordinator
        messagesVC.scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        messagesVC.maintainPositionOnInputBarHeightChanged = true // default false
        messagesVC.showMessageTimestampOnSwipeLeft = true // default false
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
        layout?.setMessageIncomingAvatarPosition(AvatarPosition(vertical: .messageCenter))
        clipBarButtonItem.image = UIImage(systemName: "paperclip")
        clipBarButtonItem.setSize(CGSize(width: 24.0, height: 36.0), animated: false)
        clipBarButtonItem.onTouchUpInside { _ in
            vm.input.startToShowPHPicker.send()
        }
        messagesVC.messageInputBar.setStackViewItems([clipBarButtonItem, .flexibleSpace], forStack: .left, animated: false)
        messagesVC.messageInputBar.setLeftStackViewWidthConstant(to: 36.0, animated: false)
        
        return messagesVC
    }
    
    func updateUIViewController(_ uiViewController: MessagesViewController, context _: Context) {
        uiViewController.messagesCollectionView.reloadData()
        scrollToBottom(uiViewController)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(vm: vm)
    }
    
    // MARK: Private
    private func scrollToBottom(_ uiViewController: MessagesViewController) {
        DispatchQueue.main.async {
            uiViewController.messagesCollectionView.scrollToLastItem(animated: false)
        }
    }
}

// MARK: - MessagesView.Coordinator + MessagesDataSource
extension MessagesUIView.Coordinator: MessagesDataSource {
    var currentSender: SenderType {
        return UserType(senderId: vm.binding.sender.id, displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in _: MessagesCollectionView) -> MessageType {
        vm.$binding.messages.wrappedValue[indexPath.section]
    }
    
    func numberOfSections(in _: MessagesCollectionView) -> Int {
        vm.$binding.messages.wrappedValue.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 30 == 0 {
            formatter.dateFormat = "M/dd HH:mm"
            return NSAttributedString(
                string: formatter.string(from: message.sentDate),
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 10),
                    .foregroundColor: UIColor.darkGray
                ]
            )
        }
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
        formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(
            string: dateString,
            attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    func messageTimestampLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
        let sentDate = message.sentDate
        formatter.dateFormat = "YYYY M/dd HH:mm"
        let sentDateString = formatter.string(from: sentDate)
        let timeLabelFont: UIFont = .boldSystemFont(ofSize: 10)
        let timeLabelColor: UIColor = .systemGray
        return NSAttributedString(
            string: sentDateString,
            attributes: [NSAttributedString.Key.font: timeLabelFont, NSAttributedString.Key.foregroundColor: timeLabelColor])
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView,
                                        for message: MessageType,
                                        at indexPath: IndexPath,
                                        in messagesCollectionView: MessagesCollectionView
    ) {
        guard let chatMessage = message as? ChatMessage else { return }
        switch chatMessage.kind {
        case .photo(let photoItem):
            guard let url = photoItem.url else { return }
            imageView.contentMode = .scaleToFill
            Nuke.loadImage(with: url, into: imageView)
        default:
            break
        }
    }
}

// MARK: - MessagesView.Coordinator + InputBarAccessoryViewDelegate
extension MessagesUIView.Coordinator: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        vm.input.startToCreateTextMessage.send(text)
        inputBar.inputTextView.text = ""
        inputBar.invalidatePlugins()
    }
}

// MARK: - MessagesView.Coordinator + MessagesLayoutDelegate, MessagesDisplayDelegate
extension MessagesUIView.Coordinator: MessagesLayoutDelegate {
    // メッセージセル間のスペース
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        indexPath.section % 3 == 0 ? 0 : 0
    }
    
    func messageTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        16
    }
    
    func messageBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        14
    }
}

extension MessagesUIView.Coordinator: MessagesDisplayDelegate {
    // メッセージの色を変更
    func textColor(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        .darkText
    }
    
    // メッセージの背景色を変更している
    func backgroundColor(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        isFromCurrentSender(message: message) ? .rgba(red: 255, green: 225, blue: 112, alpha: 0.25) : .rgba(red: 129, green: 129, blue: 129, alpha: 0.25)
    }
    
    // アイコン設定
    func configureAvatarView(
        _ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in _: MessagesCollectionView
    ) {
        avatarView.image = vm.output.partnerImage
    }
    
    // URL青色、下線を表示
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        let detectorAttributes: [NSAttributedString.Key: Any] = {
            [
                NSAttributedString.Key.foregroundColor: UIColor.blue,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.underlineColor: UIColor.blue
            ]
        }()
        
        MessageLabel.defaultAttributes = detectorAttributes
        return MessageLabel.defaultAttributes
    }
    
    // メッセージのURLに属性を適用
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url]
    }
}

extension MessagesUIView.Coordinator: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        if let containerView = cell.contentView.subviews.filter({ $0 is MessageContainerView }).first as? MessageContainerView,
           let imageView = containerView.subviews.filter({ $0 is UIImageView }).first as? UIImageView{
            guard let uiImage = imageView.image else { return }
            vm.input.startToShowImageViewer.send(uiImage)
        }
    }
    
    //MARK: - Cellのバックグラウンドをタップした時の処理
    func didTapBackground(in cell: MessageCollectionViewCell) {
        print("バックグラウンドタップ")
        
    }
    
    //MARK: - メッセージをタップした時の処理
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("メッセージタップ")
    }
    
    //MARK: - アバターをタップした時の処理
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("アバタータップ")
    }
    
    //MARK: - メッセージ上部をタップした時の処理
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("メッセージ上部タップ")
    }
    
    //MARK: - メッセージ下部をタップした時の処理
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("メッセージ下部タップ")
    }
}
