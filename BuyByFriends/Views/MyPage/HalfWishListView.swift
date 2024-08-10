//
//  HalfWishListView.swift
//  BuyByFriends
//
//  Created by toya.suzuki on 2023/10/11.
//

import SwiftUI

struct HalfWishListView: View {

    @StateObject private var vm: HalfWishListViewModel
    @FocusState private var focusedField: Bool

    init(vm: HalfWishListViewModel = HalfWishListViewModel(), userInfo: UserInfo) {
        vm.binding.userInfo = userInfo
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
//        if let key = vm.binding.userInfo.wishList.keys.first {
//            Text("\(key)")
//        }
        VStack(spacing: 24) {
            if vm.binding.userInfo.wishList.isEmpty {
                Text("ウィッシュリストを登録しよう")
                    .font(.system(size: 20, weight: .bold))
                Text("あなたが気になっている物や\n欲しい物を登録しましょう！\n友達が知らせてくれるかも👀")
                    .font(.system(size: 16, weight: .semibold))
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Asset.Colors.silver.swiftUIColor)
                Button(action: {
                    // TODO: 登録画面出す
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
                // TODO: 登録されてる場合のUI作る
            }
        }
    }
}

struct HalfWishListView_Previews: PreviewProvider {
    static var previews: some View {
        HalfWishListView(userInfo: UserInfo(dic: [:]))
    }
}
