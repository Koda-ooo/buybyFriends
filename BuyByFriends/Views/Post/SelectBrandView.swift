//
//  SelectBrandView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/01.
//

import SwiftUI

struct SelectBrandView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: PostViewModel

    var body: some View {
        VStack {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.down")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .bottom)
                    .font(.system(size: 20, weight: .medium))
            }
            Form {
                Section(header: Text("ブランド名を入力してください")) {
                    TextField("例）JieDa", text: vm.$binding.brand)
                }
            }
        }
    }
}

struct SelectBrandView_Previews: PreviewProvider {
    static var previews: some View {
        SelectBrandView(vm: PostViewModel())
    }
}
