//
//  HalfWishListView.swift
//  BuyByFriends
//
//  Created by toya.suzuki on 2023/10/11.
//

import SwiftUI

struct HalfWishListView: View {
    
    @StateObject private var vm: HalfWishListViewModel
    @FocusState private var focusedField: Bool
    
    init(vm: HalfWishListViewModel = HalfWishListViewModel(), userInfo: UserInfo) {
        vm.binding.userInfo = userInfo
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        if let key = vm.binding.userInfo.wishList.keys.first {
            Text("\(key)")
        }
    }
}

struct HalfWishListView_Previews: PreviewProvider {
    static var previews: some View {
        HalfWishListView(userInfo: UserInfo(dic: [:]))
    }
}
