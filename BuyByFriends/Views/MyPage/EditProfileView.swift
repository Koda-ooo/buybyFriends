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
                                Text(Destination.EditProfile.name.title)
                                Spacer()
                                Text(vm.binding.name)
                            case .username:
                                Text(Destination.EditProfile.username.title)
                                Spacer()
                                Text(vm.binding.username)
                            case .selfIntroduction:
                                Text(Destination.EditProfile.selfIntroduction.title)
                                Spacer()
                                Text(vm.binding.selfIntroduction)
                            case .instagram:
                                Text(Destination.EditProfile.instagram.title)
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
                EditProfileNameView(name: vm.$binding.name)
            case .username:
                EditProfileUsername(username: vm.$binding.username)
            case .selfIntroduction:
                EditProfileSelfIntroductionView(text: vm.$binding.selfIntroduction)
            case .instagram:
                EditProfileInstagramView(instagram: vm.$binding.instagramID)
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

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    path.path.removeLast()
                }) {
                    Text("保存")
                        .foregroundColor(.red)
                        .bold()
                }
            }
        }
        .onAppear {
            if vm.binding.isInitial {
                vm.binding.profileImageURL = appState.session.userInfo.profileImage
                vm.binding.name = appState.session.userInfo.name
                vm.binding.username = appState.session.userInfo.userID
                vm.binding.selfIntroduction = appState.session.userInfo.selfIntroduction
                vm.binding.instagramID = appState.session.userInfo.instagramID
            }
            vm.binding.isInitial = false
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
