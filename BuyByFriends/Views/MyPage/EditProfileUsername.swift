//
//  EditProfileUsername.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileUsername: View {
    @EnvironmentObject var path: Path
    @State private var username = "yamada_taro"

    var body: some View {
        VStack {
            UnderlinedTextField(placeholder: Destination.EditProfile.username.title, text: $username)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 30)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(Destination.EditProfile.username.title)
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

struct EditProfileUsername_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileUsername()
    }
}
