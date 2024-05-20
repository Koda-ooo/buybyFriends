//
//  NotificationView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/22.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @StateObject var vm = NotificationViewModel()
    @State private var selectedMode = Modes.request

    init(vm: NotificationViewModel = NotificationViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }

    enum Modes: String, CaseIterable, Identifiable {
        case request = "Request"
        case todo = "To Do"
        var id: String { rawValue }
    }

    var body: some View {
        VStack {
            HStack(spacing: 60) {
                ForEach(Modes.allCases, id: \.self) { mode in
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

            switch selectedMode {
            case .request: NotificationRequestView(vm: self.vm,
                                                   friendRequestList: self.appState.session.friend.requestList)
            case .todo: NotificationTodoView(vm: self.vm,
                                             deliveries: self.appState.session.delivery,
                                             uid: self.appState.session.userInfo.id)
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
