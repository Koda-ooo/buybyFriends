//
//  EditProfileSelfIntroductionView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/06.
//

import SwiftUI

struct EditProfileSelfIntroductionView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var viewModel: EditProfileViewModel
    @State private var selfIntroduction = ""

    private let maxCharacters = 150

    var body: some View {
        VStack {
            TextField("自己紹介を入力してください", text: $selfIntroduction, axis: .vertical)
                .lineLimit(1...10)
                .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                .font(.system(size: 16))
                .textFieldStyle(.plain)
                .onChange(of: selfIntroduction) { newValue in
                    if newValue.count > maxCharacters {
                        selfIntroduction = String(newValue.prefix(maxCharacters))
                    }
                }

                .padding(.horizontal, 20)
                .padding(.top, 32)
                .padding(.bottom, 8)

            Divider()
                .padding(.horizontal, 20)

            HStack {
                Spacer()

                Text("\(selfIntroduction.count)/\(maxCharacters)")
                    .font(.system(size: 14))
                    .foregroundColor(Asset.Colors.secondText.swiftUIColor)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()

        }
        .onAppear {
            selfIntroduction = viewModel.binding.selfIntroduction
        }
         .navigationBarTitleDisplayMode(.inline)
         .navigationBarBackButtonHidden(true)
         .navigationTitle("自己紹介")
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
                         viewModel.input.updateSelfIntroduction.send(selfIntroduction)
                         path.path.removeLast()
                     }) {
                         Text("完了")
                             .foregroundColor(selfIntroduction.isEmpty ? Asset.Colors.thirdText.swiftUIColor : Asset.Colors.orange.swiftUIColor)
                             .bold()
                     }
                     .disabled(selfIntroduction.isEmpty)
                 }
             }
     }
 }

struct EditProfileSelfIntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileSelfIntroductionView()
            .environmentObject(EditProfileViewModel())
    }
}
