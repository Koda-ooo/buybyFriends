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
            VStack {
                List {
                    Section(header: Text("商品管理").foregroundColor(Asset.Colors.secondText.swiftUIColor)) {
                        ForEach(ProductManagementMenus.allCases, id: \.self) { menu in
                            NavigationLink(value: menu) {
                                HStack(spacing: 8) {
                                    switch menu {
                                    case .withdrawal:
                                        Asset.Icons.yen.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("売上金の出金")
                                    case .purchasedItems:
                                        Asset.Icons.shoppingBag.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("購入した商品")
                                    case .likedItems:
                                        Asset.Icons.heart.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("いいねした商品")
                                    case .bookmarkedItems:
                                        Asset.Icons.bookmark.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("保存した商品")
                                    case .shippingAdress:
                                        Asset.Icons.truck.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("お届け先情報")
                                    }
                                }
                                .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                                .bold()
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    Section(header: Text("基本情報").foregroundColor(Asset.Colors.secondText.swiftUIColor)) {
                        ForEach(BasicInfoMenus.allCases, id: \.self) { menu in
                            NavigationLink(value: menu) {
                                HStack(spacing: 8) {
                                    switch menu {

                                    case .rateApp:
                                        Asset.Icons.star.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("BuyByFriends を応援する")
                                    case .termsOfService:
                                        Asset.Icons.note.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("利用規約")
                                    case .privacyPolicy:
                                        Asset.Icons.note.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("プライバシーポリシー")
                                    case .notation:
                                        Asset.Icons.note.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("特定商取引に基づく表記")
                                    }
                                }
                                .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                                .bold()
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    Section(header: Text("ヘルプ").foregroundColor(Asset.Colors.secondText.swiftUIColor)) {
                        ForEach(HelpMenus.allCases, id: \.self) { menu in
                            NavigationLink(value: menu) {
                                HStack(spacing: 8) {
                                    switch menu {

                                    case .contact:
                                        Asset.Icons.mail.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("お問い合わせ")
                                    case .reportBug:
                                        Asset.Icons.bug.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("バグを報告")
                                    case .faq:
                                        Asset.Icons.question.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("よくある質問")
                                    }
                                }
                                .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                                .bold()
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    Section(header: Text("SNS").foregroundColor(Asset.Colors.secondText.swiftUIColor)) {
                        ForEach(SNSMenus.allCases, id: \.self) { menu in
                            NavigationLink(value: menu) {
                                HStack(spacing: 8) {
                                    switch menu {
                                    case .tiktok:
                                        Asset.Icons.tiktok.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("TikTok")
                                    case .instagram:
                                        Asset.Icons.instagram.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("Instagram")
                                    case .twitter:
                                        Asset.Icons.twitter.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("X")

                                    }
                                }
                                .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                                .bold()
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    Section(header: Text("その他").foregroundColor(Asset.Colors.secondText.swiftUIColor)) {
                        ForEach(OtherMenus.allCases, id: \.self) { menu in
                            NavigationLink(value: menu) {
                                HStack(spacing: 8) {
                                    switch menu {
                                    case .signout:
                                        Asset.Icons.signoutAlert.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("ログアウト")
                                    case .deleteAccount:
                                        Asset.Icons.circleCrossAlert.swiftUIImage
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                        Text("アカウントの削除")
                                    }
                                }
                                .foregroundColor(Asset.Colors.alert.swiftUIColor)
                                .bold()
                            }
                        }
                        .listRowSeparator(.hidden)
                    }

                    Section {
                        VStack(spacing: 8) {
                            Asset.Icons.logo.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                            Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")")
                                .font(.subheadline)
                                .foregroundColor(Asset.Colors.thirdText.swiftUIColor)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .padding(.bottom, -20)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Asset.Colors.lightGray.swiftUIColor)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("設定")
            .navigationDestination(for: ProductManagementMenus.self) { menu in
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
                }
            }

            .navigationDestination(for: BasicInfoMenus.self) { menu in
                switch menu {
                case .rateApp:
                    EmptyView()
                case .termsOfService:
                    EmptyView()
                case .privacyPolicy:
                    EmptyView()
                case .notation:
                    EmptyView()
                }
            }

            .navigationDestination(for: HelpMenus.self) { menu in
                switch menu {
                case .contact:
                    ContactView()
                case .reportBug:
                    EmptyView()
                case .faq:
                    EmptyView()
                }
            }

            .navigationDestination(for: SNSMenus.self) { menu in
                switch menu {
                case .tiktok:
                    EmptyView()
                case .instagram:
                    EmptyView()
                case .twitter:
                    EmptyView()
                }
            }

            .navigationDestination(for: OtherMenus.self) { menu in
                switch menu {
                case .signout:
                    EmptyView()
                case .deleteAccount:
                    DeleteAccountView()

                }
            }
            .navigationDestination(for: Withdraw.self) { withdraw in
                RequestWithdrawView(withdraw: withdraw)
            }
        }
    }
}
enum ProductManagementMenus: CaseIterable {
    case withdrawal
    case purchasedItems
    case likedItems
    case bookmarkedItems
    case shippingAdress
}

enum BasicInfoMenus: CaseIterable {
    case rateApp
    case termsOfService
    case privacyPolicy
    case notation
}

enum HelpMenus: CaseIterable {
    case contact
    case reportBug
    case faq
}

enum SNSMenus: CaseIterable {
    case tiktok
    case instagram
    case twitter
}

enum OtherMenus: CaseIterable {
    case signout
    case deleteAccount
}

struct MyPageHumbergerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageHumbergerMenuView()
            .environmentObject(Path())
    }
}
