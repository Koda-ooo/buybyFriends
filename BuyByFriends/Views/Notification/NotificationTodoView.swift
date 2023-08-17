//
//  NotificationTodoView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/25.
//

import SwiftUI

struct NotificationTodoView: View {
    @StateObject var vm: NotificationViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NotificationTodoView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationTodoView(vm: NotificationViewModel())
    }
}
