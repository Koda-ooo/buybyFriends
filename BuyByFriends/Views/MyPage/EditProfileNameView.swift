//
//  EditProfileNameView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileNameView: View {
    @EnvironmentObject var path: Path
    @Binding var name: String

    var body: some View {
        VStack {
            UnderlinedTextField(placeholder: Destination.EditProfile.name.title, text: $name)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 30)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(Destination.EditProfile.name.title)
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
        EditProfileNameView(name: .constant("山田太郎"))
    }
}
