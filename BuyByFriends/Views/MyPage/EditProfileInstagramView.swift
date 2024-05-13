//
//  EditProfileInstagramView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileInstagramView: View {
    @EnvironmentObject var path: Path
    @State private var instagram = "yamada_taro_insta"

    var body: some View {
        VStack {
            UnderlinedTextField(placeholder: Destination.EditProfile.instagram.title, text: $instagram)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 30)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(Destination.EditProfile.instagram.title)
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

struct EditProfileInstagramView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileInstagramView()
    }
}
