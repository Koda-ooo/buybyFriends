//
//  EditProfileInstagramView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileInstagramView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var viewModel: EditProfileViewModel
    @State private var instagramID: String = ""

    var body: some View {
        VStack {
            HStack {
                if !instagramID.isEmpty {
                    Text("@")
                        .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                        .font(.system(size: 16))
                }
                TextField("インスタグラムIDを入力してください", text: $instagramID)
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    .frame(height: 32)
                    .font(.system(size: 16))
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.never)

                if !instagramID.isEmpty {
                    Button(action: {
                        instagramID = ""
                    }) {
                        Asset.Icons.clearButton.swiftUIImage
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
            .onAppear {
                instagramID = viewModel.binding.instagramID
            }
            Divider()

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("インスタグラム")
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
                        viewModel.input.updateInstagramID.send(instagramID)
                        path.path.removeLast()
                    }) {
                        Text("完了")
                            .foregroundColor(instagramID.isEmpty ? Asset.Colors.thirdText.swiftUIColor : Asset.Colors.orange.swiftUIColor)
                            .bold()
                    }
                }
            }
    }
}

struct EditProfileInstagramView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileInstagramView()
            .environmentObject(EditProfileViewModel())
    }
}
