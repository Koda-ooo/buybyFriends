//
//  ListView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var path: Path
    @EnvironmentObject var tabBar: HideTabBar
    @StateObject var vm: ListViewModel
    @Namespace var namespace
    
    enum modes: String, CaseIterable, Identifiable {
        case friends = "Friends"
        case foryou = "For You"
        var id: String { rawValue }
    }
    
    init(vm: ListViewModel = ListViewModel()) {
        vm.input.startToObserveForYouPosts.send()
        vm.input.startToObserveFriendsPosts.send()
        _vm = StateObject(wrappedValue: vm)
    }
    
    @State private var selectedMode = modes.friends
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                if !vm.binding.isShownPostDetail {
                    if selectedMode == .friends {
                        HStack(spacing: 20) {
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
                        .frame(maxWidth: UIScreen.main.bounds.width*0.85)
                        .padding(.top, 20)
                        
                        ListFriendsView(vm: self.vm, namespace: namespace)
                    }
                    
                    if selectedMode == .foryou {
                        ScrollView(showsIndicators: false) {
                            HStack(spacing: 20) {
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
                            .frame(maxWidth: UIScreen.main.bounds.width*0.85)
                            .padding(.top, 20)
                            
                            ListForYouView(vm: self.vm)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Destination.List.self) { destination in
            switch destination {
            case .friend: SearchFriendsView()
            case .notification: NotificationView()
            case .message: MessageListView()
            }
            
        }
        .navigationDestination(for: ChatRoom.self) { chatRoom in
            MessageView(chatRoom: chatRoom)
        }
        .navigationTitle("BuyByFriends")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink(value: Destination.List.friend) {
                    Image(systemName: "person.2")
                        .accentColor(.black)
                        .font(.system(size: 17))
                }
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(value: Destination.List.notification) {
                    Image(systemName: "bell")
                        .accentColor(.black)
                        .font(.system(size: 17))
                }
                
                NavigationLink(value: Destination.List.message) {
                    Image(systemName: "text.bubble")
                        .accentColor(.black)
                        .font(.system(size: 17))
                }
            }
        }
        
        if vm.binding.isShownPostDetail {
            PostDetailView(isShownPostDetailView: vm.$binding.isShownPostDetail,
                           post: vm.binding.selectedPost,
                           index:vm.binding.selectedIndex,
                           namespace: self.namespace)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
