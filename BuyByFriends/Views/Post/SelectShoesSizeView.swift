//
//  SelectShoesSizeView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/10.
//

import SwiftUI

struct SelectShoesSizeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: PostViewModel
    let sizes = ["21cm", "21.5cm", "22cm", "22.5cm", "23cm", "23.5cm", "24cm", "24.5cm", "25cm", "25.5cm", "26cm", "26.5cm", "27cm", "27.5cm", "28cm", "28.5cm", "29cm", "29.5cm", "その他"]
    
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
            listLayout()
        }
    }
    
    private func listLayout() -> some View {
        return List() {
            ForEach(sizes, id: \.self) { size in
                HStack {
                    Button {
                        vm.binding.size = size
                    } label: {
                        Image(systemName: vm.binding.size == size ? "button.programmable" : "circle")
                            .foregroundColor(vm.binding.size == size ? Color.yellow : Color.black)
                    }
                    Text(size)
                        .bold(true)
                        .padding(.leading, 10)
                }
            }
            .frame(height: 37)
            .font(.system(size: 20))
        }
        .listStyle(.inset)
    }
}

struct SelectShoesSizeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectShoesSizeView(vm: PostViewModel())
    }
}
