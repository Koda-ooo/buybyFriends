//
//  EditWishListView.swift
//  BuyByFriends
//
//  Created by toya.suzuki on 2023/10/11.
//

import SwiftUI

struct EditWishListView: View {
    @EnvironmentObject var path: Path
    @StateObject private var vm: EditWishListViewModel
    @FocusState private var focusedField: Bool

    init(vm: EditWishListViewModel = EditWishListViewModel(), genre: InventoryGenre) {
        vm.binding.genre = genre
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 32)
            ZStack(alignment: .topLeading) {
                TextEditor(text: vm.$binding.text)
                    .focused($focusedField)
                    .padding(.horizontal, -4)
                    .frame(height: 200)
                if vm.binding.text.isEmpty {
                    Text("今、欲しいアクセサリーの入力をしてください。\n\n例. ラッパーみたいなゴツゴツしてる金のチェーンが欲しい！！")
                        .foregroundColor(Asset.Colors.silver.swiftUIColor)
                        .font(.system(size: 14))
                        .kerning(1)
                        .lineSpacing(3)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 20)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(Asset.Colors.silver.swiftUIColor)
                .padding(.horizontal, 20)

            Spacer()

            Button(action: {
                vm.input.startToSaveWishList.send()
            }, label: {
                Text("登録する")
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity)
            })
            .frame(width: 120, height: 48)
            .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
            .background(Asset.Colors.chromeYellow.swiftUIColor)
            .cornerRadius(24)

            Spacer()

        }
        .navigationTitle(vm.binding.genre.text)
        .onChange(of: vm.output.isSuccess) { newValue in
            if newValue {
                path.path.removeLast(path.path.count)
            }
        }
    }
}

struct EditWishListView_Previews: PreviewProvider {
    static var previews: some View {
        EditWishListView(genre: .outer)
    }
}
