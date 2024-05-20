//
//  ListForYouView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/10.
//

import SwiftUI

struct ListForYouView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var vm: ListViewModel

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
            ForEach(vm.output.forYouPosts) { post in
                NavigationLink(value: post) {
                    if let imageURLString = post.images.first {
                        AsyncImage(url: URL(string: imageURLString)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .frame(
                    minHeight: UIScreen.main.bounds.height*0.19,
                    maxHeight: UIScreen.main.bounds.height*0.19
                )
                .cornerRadius(5)
            }
        }
        .padding()
    }
}

struct ListForYouView_Previews: PreviewProvider {
    static var previews: some View {
        ListForYouView(vm: ListViewModel())
    }
}
