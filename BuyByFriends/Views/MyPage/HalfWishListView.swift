//
//  HalfWishListView.swift
//  BuyByFriends
//
//  Created by toya.suzuki on 2023/10/11.
//

import SwiftUI

struct HalfWishListView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var vm: HalfWishListViewModel
    @FocusState private var focusedField: Bool
    private var onTap: (() -> Void)?

    init(vm: HalfWishListViewModel = HalfWishListViewModel(), userInfo: UserInfo, onTap: (() -> Void)? = nil) {
        vm.binding.userInfo = userInfo
        _vm = StateObject(wrappedValue: vm)
        self.onTap = onTap
    }

    var body: some View {
        VStack(spacing: 24) {
            if vm.binding.userInfo.wishList.isEmpty {
                Text("ウィッシュリストを登録しよう")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 12)
                Text("あなたが気になっている物や\n欲しい物を登録しましょう！\n友達が知らせてくれるかも👀")
                    .font(.system(size: 16, weight: .semibold))
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Asset.Colors.silver.swiftUIColor)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    onTap?()
                }, label: {
                    Text("ウィッシュリストを登録する")
                        .font(.system(size: 14, weight: .bold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .lineSpacing(3)
                })
                .frame(height: 44)
                .foregroundColor(Asset.Colors.white.swiftUIColor)
                .background(Asset.Colors.jetBlack.swiftUIColor)
                .cornerRadius(22)
                .padding(.horizontal, 20)
                .padding(.top, 12)
            } else {
                Spacer(minLength: 0)
                Text(vm.binding.userInfo.inventoryGenre()?.text ?? "")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 12)
                Text(vm.binding.userInfo.wishListText())
                    .font(.system(size: 16, weight: .semibold))
                    .frame(minHeight: 74)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Asset.Colors.silver.swiftUIColor)
                VStack(spacing: 16) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        // TODO: 編集する
                    }, label: {
                        Text("ウィッシュリストを編集する")
                            .font(.system(size: 14, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .lineSpacing(3)
                    })
                    .frame(height: 44)
                    .foregroundColor(Asset.Colors.white.swiftUIColor)
                    .background(Asset.Colors.jetBlack.swiftUIColor)
                    .cornerRadius(22)
                    .padding(.horizontal, 20)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        // TODO: 削除する
                    }, label: {
                        Text("ウィッシュリストを削除する")
                            .font(.system(size: 14, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .lineSpacing(3)
                    })
                    .frame(height: 44)
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(.vertical, 12)
    }
}

struct HalfWishListView_Previews: PreviewProvider {
    static var previews: some View {
        HalfWishListView(userInfo: UserInfo(dic: [:]))
    }
}
