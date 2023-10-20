//
//  MyPageInventoryListView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/08/28.
//

import SwiftUI

struct MyPageInventoryListView: View {
    @EnvironmentObject var path: Path
    @StateObject var vm: MyPageInventoryListViewModel
    
    init(vm: MyPageInventoryListViewModel = MyPageInventoryListViewModel(),
         userInfo: UserInfo,
         isMyPage: Bool) {
        vm.binding.isMyPage = isMyPage
        vm.binding.userInfo = userInfo
        
        if isMyPage {
            vm.input.startToFetchInventory.send()
        } else {
            vm.binding.userInventories = userInfo.inventoryList.enumerated().map { (index, name) in
                var inventory = Inventory(dic: [:])
//                inventory.id = index
                inventory.name = name
                return inventory
            }
        }
        
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 30) {
            Spacer()
                .frame(height: 20)
            
            FlexibleView(
                data: vm.binding.userInventories,
                spacing: 10,
                alignment: .leading
            ) { item in
                Button(action: {
                    guard var selectedItem = vm.binding.userInventories.first(where: {$0.id == item.id}) else { return }
                    selectedItem.selected.toggle()
                }) {
                    HStack {
                        Text(item.name)
                            .font(.system(size: 13))
                            .bold()
                        if let selectedItem = vm.binding.userInventories.first(where: { $0.id == item.id}) {
                            if selectedItem.selected {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                            } else {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                            }
                        } else {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundColor(vm.binding.userInventories.first(where: {$0.id == item.id})?.selected ?? false ? .white : .black)
                    .background(vm.binding.userInventories.first(where: {$0.id == item.id})?.selected ?? false ? .black : .white)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            Spacer()
            
            Button(action: {
                if vm.binding.isMyPage {
                    vm.input.startToUpdateMyInventories.send()
                } else {
                    // 通知を送る
                    
                }
                path.path.removeLast()
            }) {
                if vm.binding.isMyPage {
                    Text("持ち物リストを更新する")
                } else {
                    Text("リクエストを送る")
                }
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            .font(.system(size: 20, weight: .bold))
            .accentColor(Color.white)
            .background(Color.black)
            .cornerRadius(.infinity)
            .padding(.trailing, 30)
            
            if !vm.binding.isMyPage {
                Text("\(vm.binding.userInfo.userID)さんに匿名のリクエストが届きます。")
                    .bold()
            }
        }
        .padding(.leading, 30)
        .navigationBarBackButtonHidden(true)
        .navigationTitle( (vm.binding.isMyPage ? "" : "\(vm.binding.userInfo.userID)さんの")+"持ち物リスト")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.path.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct MyPageInventoryListView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageInventoryListView(userInfo: UserInfo(dic: [:]), isMyPage: true)
    }
}
