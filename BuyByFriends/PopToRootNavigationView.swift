//
//  PopToRootNavigationView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/27.
//

import Foundation
import SwiftUI

enum Screen {
    case home
    case profile
    case settings
}

class NavigationPath: ObservableObject {
    @Published var currentPath: [String] = []
}

struct TestView: View {
    @StateObject private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationView {
            VStack {
                switch navigationPath.currentPath.last {
                case .home:
                    HomeView()
                case .profile:
                    ProfileView()
                case .settings:
                    SettingsView()
                case nil:
                    HomeView()
                }
            }
            .navigationBarItems(trailing: navigationBarTrailingItems)

        }
        .environmentObject(navigationPath)
    }
    
    var navigationBarTrailingItems: some View {
        Group {
            if navigationPath.currentPath.last != nil {
                Button(action: {
                    navigationPath.currentPath.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            Text("Home View")
            Button("Go to Profile", action: {
                navigationPath.currentPath.append("")
            })
            Button("Go to Settings", action: {
                navigationPath.currentPath.append(.settings)
            })
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            Text("Profile View")
            Button("Go to Home", action: {
                navigationPath.currentPath.append(.home)
            })
            Button("Go to Settings", action: {
                navigationPath.currentPath.append(.settings)
            })
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var navigationPath: NavigationPath
    var body: some View {
        VStack {
            Text("Settings View")
            Button("Go to Home", action: {
                navigationPath.currentPath.append(.home)
            })
            Button("Go to Profile", action: {
                navigationPath.currentPath.append(.profile)
            })
        }
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
