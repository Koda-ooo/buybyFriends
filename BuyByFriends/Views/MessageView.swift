//
//  MessageView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/26.
//

import SwiftUI
import PhotosUI
import Agrume

struct MessageView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @StateObject var vm = MessageViewModel()
    let chatRoom: ChatRoom
    
    static var config: PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        return config
    }
    
    var body: some View {
        ZStack {
            MessagesUIView(vm: self.vm)
            if vm.binding.isShownImageViewer {
                AgrumeView(
                    image: vm.output.viewerImage,
                    isPresenting: vm.$binding.isShownImageViewer
                )
            }
        }
        .onAppear {
            vm.binding.chatRoomID = chatRoom.id
            vm.binding.sender = appState.session.userInfo
            vm.input.startToObserveMessages.send()
            vm.input.startToFetchPartnerUserInfo.send(chatRoom.members.first ?? "")
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if vm.binding.isShownImageViewer {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        vm.binding.isShownImageViewer = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            } else {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
            
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(vm.output.partner.name)
                        .lineLimit(1)
                        .font(.system(size: 15, weight: .medium))
                    Text(vm.output.partner.userID)
                        .lineLimit(1)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .sheet(isPresented: vm.$binding.isShownPHPicker) {
            SwiftUIPHPicker(configuration: MessageView.config ) { results in
                results.forEach { result in
                    vm.createUIImageFromPHPikcerResult(image: result)
                }
            }
        }
        
    }
}

struct MessageView_Previews: PreviewProvider {
    static var chatRoom = ChatRoom(dic: [:])
    
    static var previews: some View {
        MessageView(chatRoom: chatRoom)
    }
}
