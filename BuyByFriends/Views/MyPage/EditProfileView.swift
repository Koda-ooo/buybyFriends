//
//  EditProfileView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = EditProfileViewModel()

    var body: some View {
        VStack {
            Button(action: {

            }) {
                AsyncImage(url: URL(string: vm.binding.profileImageURL)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(
                width: UIScreen.main.bounds.height*0.11,
                height: UIScreen.main.bounds.height*0.11
            )
            .clipShape(Circle())
            .padding(.vertical, 16)

            Text("About you")
                .bold()

            List {
                ForEach(Destination.EditProfile.allCases, id: \.self) { selected in
                    NavigationLink(value: selected) {
                        HStack {
                            switch selected {
                            case .name:
                                Text("名前")
                                Spacer()
                                Text(vm.binding.name)
                            case .username:
                                Text("ユーザーネーム")
                                Spacer()
                                Text(vm.binding.username)
                            case .selfIntroduction:
                                Text("自己紹介")
                                Spacer()
                                Text(vm.binding.selfIntroduction)
                            case .instagram:
                                Text("Instagram")
                                Spacer()
                                Text(vm.binding.instagramID)
                            }
                        }.padding(.vertical, 8)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("プロフィールを編集")
        .navigationDestination(for: Destination.EditProfile.self) { selected in
            switch selected {
            case .name:
                EditProfileNameView(name: $vm.binding.name)
                    .environmentObject(vm)
            case .username:
                EditProfileUsername(username: $vm.binding.username)
                    .environmentObject(vm)
            case .selfIntroduction:
                EditProfileSelfIntroductionView(selfIntroduction: $vm.binding.selfIntroduction)
                    .environmentObject(vm)
            case .instagram:
                EditProfileInstagramView(instagramID: $vm.binding.instagramID)
                    .environmentObject(vm)

            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.path.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            vm.binding.profileImageURL = appState.session.userInfo.profileImage
            vm.binding.name = appState.session.userInfo.name
            vm.binding.username = appState.session.userInfo.userID
            vm.binding.selfIntroduction = appState.session.userInfo.selfIntroduction
            vm.binding.instagramID = appState.session.userInfo.instagramID
        }
        // プロフィールが更新されたときの処理を追加
        .onChange(of: vm.binding.name) { newName in
            appState.session.userInfo.name = newName
        }
        .onChange(of: vm.binding.username) { newUsername in
            appState.session.userInfo.userID = newUsername
        }
        .onChange(of: vm.binding.selfIntroduction) { newSelfIntroduction in
            appState.session.userInfo.selfIntroduction = newSelfIntroduction
        }
        .onChange(of: vm.binding.instagramID) { newInstagramID in
            appState.session.userInfo.instagramID = newInstagramID
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
