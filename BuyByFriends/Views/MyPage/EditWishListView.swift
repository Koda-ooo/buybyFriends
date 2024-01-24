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
                    Text("色、素材、重さ、定価、注意点など\n\n例）去年、原宿の古着屋さんで買ったTシャツ！\nスター・トレックの事は知らなかったけど、ビジュが良くて一目惚れした❤️\nTシャツなんてなんぼあってもいいですからね〜\n\nたぶん、10,000円ぐらいで買ってサイズはL\nTシャツは一年中着れるしこれはガチでおすすめ\nピンホールあるけどそれも古着の醍醐味でしょ😥")
                        .foregroundColor(Color(uiColor: .placeholderText))
                        .font(.system(size: 13))
                        .kerning(1)
                        .lineSpacing(3)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                }
            }
            .padding()
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray)
            
            Spacer()
            
            Button(action: {
                vm.input.startToSaveWishList.send()
            }) {
                Text("登録する")
                    .frame(maxWidth: 128, minHeight: 48)
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundColor(.white)
            //.accentColor(Color.white)
            .background(.black)
            //.overlay(RoundedRectangle(cornerRadius: 15).stroke(.black, lineWidth: 1))
            .cornerRadius(20)
            
            Spacer()
            
        }
        .navigationTitle(vm.binding.genre.text)
        .onChange(of: vm.output.isSuccess) { newValue in
            if newValue {
                path.path.removeLast(path.path.count)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    print("check")
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }

            }
        }
    }
}

struct EditWishListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditWishListView(genre: .outer)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
