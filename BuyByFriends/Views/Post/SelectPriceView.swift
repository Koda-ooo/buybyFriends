//
//  SelectPriceView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/01.
//

import SwiftUI

struct SelectPriceView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: PostViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("価格を入力してください")) {
                    HStack {
                        TextField("Price", text: vm.$binding.price)
                        Text("円")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct SelectPriceView_Previews: PreviewProvider {
    static var previews: some View {
        SelectPriceView(vm: PostViewModel())
    }
}
