//
//  NotificationView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = NotificationViewModel()
    @State private var selectedMode = modes.request
    
    enum modes: String, CaseIterable, Identifiable {
        case request = "Request"
        case todo = "To Do"
        var id: String { rawValue }
    }

    var body: some View {
        VStack {
            HStack(spacing: 60) {
                ForEach(modes.allCases, id: \.self) { mode in
                    Button(action: {
                        selectedMode = mode
                    }, label: {
                        Text(mode.rawValue)
                            .tag(mode)
                            .foregroundColor(selectedMode == mode ? .yellow: .black)
                            .font(.system(size: 20, weight: .bold))
                    })
                }
            }
            .padding()
            
            switch selectedMode{
            case .request: NotificationRequestView(vm: self.vm)
            case .todo: NotificationTodoView(vm: self.vm)
            }
            Spacer()
        }
        .navigationTitle("お知らせ")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
