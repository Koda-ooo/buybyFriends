//
//  EditProfileSelfIntroductionView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileSelfIntroductionView: View {
    @EnvironmentObject var path: Path
    @State private var selfIntroductionText = "よろしくお願いいたします。"
    private let maxLength = 150

    var body: some View {
        VStack {
            TextEditor(text: Binding<String>(
                get: { selfIntroductionText },
                set: { selfIntroductionText = String($0.prefix(maxLength)) }
            ))
            .frame(height: 150)
            Divider()
                .padding(.horizontal, -20)
            HStack {
                Spacer()
                Text("\(selfIntroductionText.count) / \(maxLength.description)")
                    .foregroundStyle(Color.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 30)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(Destination.EditProfile.selfIntroduction.title)
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

struct EditProfileSelfIntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileSelfIntroductionView()
    }
}
