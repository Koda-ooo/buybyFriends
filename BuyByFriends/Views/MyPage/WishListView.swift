//
//  WishListView.swift
//  BuyByFriends
//
//  Created by toya.suzuki on 2023/10/11.
//

import SwiftUI

struct WishListView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("カテゴリーを選択する")
                .font(.system(size: 18, weight: .bold))
                .padding(.top, 24)
                .padding(.leading, 16)

            List {
                ForEach(InventoryGenre.allCases, id: \.self) { genre in
                    NavigationLink(value: genre) {
                        Text(genre.text)
                            .font(.system(size: 16, weight: .bold))
                            .frame(height: 32)
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("ウィッシュリスト")
            .navigationDestination(for: InventoryGenre.self) { genre in
                EditWishListView(genre: genre)
            }
        }
    }
}

struct WishListView_Previews: PreviewProvider {
    static var previews: some View {
        WishListView()
    }
}
