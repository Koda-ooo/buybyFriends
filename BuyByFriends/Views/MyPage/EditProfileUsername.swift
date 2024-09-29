//
//  EditProfileUsername.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileUsername: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var viewModel: EditProfileViewModel
    @State private var username: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("ユーザーネームを入力してください", text: $username)
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    .frame(height: 32)
                    .font(.system(size: 16))
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.never)

                if !username.isEmpty {
                    Button(action: {
                        username = ""
                    }) {
                        Asset.Icons.clearButton.swiftUIImage
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
            .onAppear {
                username = viewModel.binding.username
            }
            Divider()

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("ユーザーネーム")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.path.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.input.updateUsername.send(username)
                    path.path.removeLast()
                }) {
                    Text("完了")
                        .foregroundColor(username.isEmpty ? Asset.Colors.thirdText.swiftUIColor : Asset.Colors.orange.swiftUIColor)
                        .bold()
                }

            }
        }
    }
}

struct EditProfileUsername_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileUsername()
            .environmentObject(EditProfileViewModel())
    }
}
