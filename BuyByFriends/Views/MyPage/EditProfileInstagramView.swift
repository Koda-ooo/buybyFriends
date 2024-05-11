//
//  EditProfileInstagramView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileInstagramView: View {
    @EnvironmentObject var path: Path

    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
    }
}

struct EditProfileInstagramView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileInstagramView()
    }
}
