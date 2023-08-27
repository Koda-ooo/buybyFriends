//
//  InitialView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/17.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var path: Path
    @EnvironmentObject var tabBar: HideTabBar
    @StateObject var vm = InitialViewModel()
    
    var body: some View {
        if appState.session.isLoggedIn {
            NavigationStack(path: $path.path) {
                GeometryReader { view in
                    switch vm.binding.selectedView {
                    case .first:
                        VStack(spacing: 0) {
                            ListView()
                            if !tabBar.isHidden {
                                TabBarView(vm: self.vm, view: view)
                            }
                        }
                    case .second: Text("")
                    case .third:
                        VStack(spacing: 0) {
                            MyPageView(userUID: appState.session.userInfo.id)
                            TabBarView(vm: self.vm, view: view)
                        }
                    }
                }
            }
            .accentColor(.black)
            .sheet(isPresented: vm.$binding.isShownPostView){
                PostView()
            }
            .onChange(of: vm.binding.selectedView) {
                if vm.binding.selectedView == .second {
                    self.vm.binding.isShownPostView = true
                    self.vm.binding.selectedView = self.vm.binding.oldSelectedView
                } else {
                    self.vm.binding.oldSelectedView = $0
                }
            }
            .onChange(of: vm.output.userInfo) { userInfo in
                appState.session.userInfo = userInfo
            }
            .onChange(of: vm.output.isLoggedIn) { result in
                appState.session.isLoggedIn = result
            }
            .onChange(of: vm.output.notification) { notification in
                appState.session.notification = notification
            }
            .onChange(of: vm.output.friend) { friend in
                appState.session.friend = friend
            }
            .onChange(of: vm.output.delivery) { delivery in
                appState.session.delivery = delivery
            }
        } else {
            if vm.output.isSignIn == true {
                UsernameView()
            } else {
                WelcomeView()
                    .onChange(of: vm.output.userInfo) { userInfo in
                        appState.session.userInfo = userInfo
                    }
                    .onChange(of: vm.output.isLoggedIn) { result in
                        if result == true {
                            path.path.removeLast(path.path.count)
                            appState.session.isLoggedIn = result
                        }
                    }
                    .onChange(of: vm.output.notification) { notification in
                        appState.session.notification = notification
                    }
                    .onChange(of: vm.output.friend) { friend in
                        appState.session.friend = friend
                    }
                    .onChange(of: vm.output.delivery, perform: { delivery in
                        appState.session.delivery = delivery
                    })
                    .onChange(of: vm.output.uid) { uid in
                        appState.session.userInfo.id = uid
                    }
                    .onAppear {
//                        vm.input.startToLogOut.send()
                        vm.input.startToObserveAuthChange.send()
                    }
            }
        }
    }
}

enum Tab: Int {
    case first, second, third
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}

struct TabBarView: View {
    @ObservedObject var vm: InitialViewModel
    let view: GeometryProxy
    
    var body: some View {
        HStack(spacing: view.size.width*0.15) {
            tabBarItem(.first, icon: "house", selectedIcon: "house.fill")
            tabBarItem(.second, icon: "plus.circle", selectedIcon: "plus.circle.fill")
            tabBarItem(.third, icon: "person", selectedIcon: "person.fill")
        }
        .frame(height: view.size.height*0.05)
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
    
    func tabBarItem(_ tab: Tab, icon: String, selectedIcon: String) -> some View {
        Image(systemName: (vm.binding.selectedView == tab ? selectedIcon : icon))
            .font(.system(size: 24))
            .foregroundColor(vm.binding.selectedView == tab ? .primary : .black)
            .frame(width: 65, height: 42)
            .onTapGesture {
                vm.binding.selectedView = tab
            }
    }
}
