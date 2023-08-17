//
//  SelectConditionView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/01.
//

import SwiftUI

struct SelectConditionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: PostViewModel
    let conditions = ["新品・未使用", "ほぼ未使用", "目立った傷や汚れなし", "やや傷や汚れあり", "傷や汚れあり"]
    
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
            ForEach(conditions, id: \.self) { condition in
                HStack {
                    Button {
                        vm.binding.condition = condition
                    } label: {
                        Image(systemName: vm.binding.condition == condition ? "button.programmable" : "circle")
                            .foregroundColor(vm.binding.condition == condition ? Color.yellow : Color.black)
                    }
                    Text(condition)
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

struct SelectConditionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectConditionView(vm: PostViewModel())
    }
}
