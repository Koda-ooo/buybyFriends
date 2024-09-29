//
//  WishListView.swift
//  BuyByFriends
//
//  Created by toya.suzuki on 2023/10/11.
//

import SwiftUI

struct WishListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isShow: Bool = false
    @State var selectGenre: InventoryGenre?
    var onTapRegister: ((InventoryGenre, String) -> Void)?

    var body: some View {
        VStack(alignment: .leading) {
            Text("カテゴリーを選択する")
                .font(.system(size: 18, weight: .bold))
                .padding(.top, 24)
                .padding(.leading, 16)

            List(InventoryGenre.allCases, id: \.id) { genre in
                Button(action: {
                    selectGenre = genre
                    isShow = true
                }, label: {
                    Text(genre.text)
                        .font(.system(size: 16, weight: .bold))
                        .frame(height: 32)
                })
            }
            .listStyle(.plain)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("ウィッシュリスト")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                }
            }
        }
        .navigationDestination(isPresented: $isShow) {
            if let selectGenre {
                EditWishListView(genre: selectGenre, onTapRegister: onTapRegister)
            }
        }
    }
}

struct WishListView_Previews: PreviewProvider {
    static var previews: some View {
        WishListView()
    }
}
