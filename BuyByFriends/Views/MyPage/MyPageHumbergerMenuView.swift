//
//  MyPageHumbergerMenuView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/02.
//

import SwiftUI

struct MyPageHumbergerMenuView: View {
    @EnvironmentObject var path: Path
    
    init() {
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }

        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationStack(path: $path.path) {
            List {
                ForEach(MyPageHumbergerMenus.allCases, id: \.self) { menu in
                    NavigationLink(value: menu) {
                        HStack {
                            switch menu {
                            case .withdrawal:
                                Image(systemName: "yensign.circle")
                                Text("売上金の出金")
                            case .purchasedItems:
                                Image("shoppingBag")
                                Text("購入した商品")
                            case .likedItems:
                                Image("heart")
                                Text("いいねした商品")
                            case .bookmarkedItems:
                                Image("bookmark")
                                Text("保存した商品")
                            case .shippingAdress:
                                Image("truck")
                                Text("お届け先情報")
                            case .termsOfService:
                                Image("note")
                                Text("利用規約")
                            case .privacyPolicy:
                                Image("note")
                                Text("プライバシーポリシー")
                            case .notation:
                                Image("note")
                                Text("特定商取引に基づく表記")
                            case .signout:
                                Image("signout")
                                Text("ログアウト")
                            case .deleteAccount:
                                Image("circleCross")
                                Text("アカウントの削除")
                            case .contact:
                                Image("envelope")
                                Text("お問い合わせ")
                            }
                        }
                        .bold()
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("メニュー")
            .navigationDestination(for: MyPageHumbergerMenus.self) { menu in
                switch menu {
                case .withdrawal:
                    WithdrawView()
                case .purchasedItems:
                    PurchasedItemsView()
                case .likedItems:
                    LikedItemsView()
                case .bookmarkedItems:
                    BookmarkedItemsView()
                case .shippingAdress:
                    ShippingAdressView()
                case .termsOfService:
                    EmptyView()
                case .privacyPolicy:
                    EmptyView()
                case .notation:
                    EmptyView()
                case .signout:
                    EmptyView()
                case .deleteAccount:
                    DeleteAccountView()
                case .contact:
                    ContactView()
                }
            }
            .navigationDestination(for: Withdraw.self) { withdraw in
                RequestWithdrawView(withdraw: withdraw)
            }
        }
    }
}

enum MyPageHumbergerMenus: CaseIterable {
    case withdrawal
    case purchasedItems
    case likedItems
    case bookmarkedItems
    case shippingAdress
    case termsOfService
    case privacyPolicy
    case notation
    case signout
    case deleteAccount
    case contact
}

struct MyPageHumbergerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageHumbergerMenuView()
    }
}
