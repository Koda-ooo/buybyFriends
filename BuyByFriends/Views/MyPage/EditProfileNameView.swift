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
            TextField("名前を入力してください", text: $name)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            name = viewModel.binding.name
                        }
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
                        Text("保存")
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
