//
//  EditProfileNameView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileNameView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var viewModel: EditProfileViewModel
    @State private var name: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("名前を入力してください", text: $name)
                    .frame(height: 32)
                    .font(.system(size: 16))
                    .textFieldStyle(.plain)

                if !name.isEmpty {
                    Button(action: {
                        name = ""
                    }) {
                        Asset.Icons.clearButton.swiftUIImage
                    }
                }
            }
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    .onAppear {
                        name = viewModel.binding.name
                    }
                    Divider()

                    Spacer()

        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("名前")
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
                        viewModel.binding.name = name
                        path.path.removeLast()
                    }) {
                        Text("完了")
                            .foregroundColor(.red)
                            .bold()
                    }
                }
            }
    }
}

struct EditProfileNameView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileNameView()
            .environmentObject(EditProfileViewModel())
    }
}
