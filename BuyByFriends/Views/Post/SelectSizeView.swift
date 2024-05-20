//
//  SelectSizeView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/01.
//

import SwiftUI

struct SelectSizeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: PostViewModel
    let sizes = ["S", "M", "L", "XL"]

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
        return List {
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

struct SelectSizeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSizeView(vm: PostViewModel())
    }
}
