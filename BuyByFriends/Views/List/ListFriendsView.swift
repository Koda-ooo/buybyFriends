//
//  ListFriendsView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/10.
//

import SwiftUI
import Kingfisher

struct ListFriendsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var tabBar: HideTabBar
    @StateObject var vm: ListViewModel
    @GestureState private var dragOffset: CGFloat = 0
    var namespace: Namespace.ID
    
    var body: some View {
        GeometryReader { bodyView in
            ZStack {
                LazyHStack(spacing: vm.carouselItemPadding()) {
                    ForEach(vm.binding.infinityArray.indices, id: \.self) { index in
                        let postViewID = UUID().uuidString
                        let post = vm.binding.infinityArray[index]
                        
                        FriendsPostView(vm: self.vm,
                                        postViewID: postViewID,
                                        namespace: self.namespace,
                                        post: post)
                        .frame(
                            width: vm.carouselItemWidth(bodyView: bodyView),
                            height: index == vm.binding.currentIndex ? bodyView.size.height * 0.75 : bodyView.size.height * 0.6)
                        .padding(.leading, vm.carouselLeadingPadding(index: index, bodyView: bodyView))
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 15, y: 15)
                        .rotation3DEffect(
                            Angle(degrees: vm.binding.currentIndex == index ? Double(0) : vm.binding.currentIndex - index > 0 ?  Double(-5):Double(5)),
                            axis: (x: 0, y: 1.0, z: 0)
                        )
                    }
                }
                .offset(x: self.dragOffset)
                .offset(x: vm.carouselOffsetX(bodyView: bodyView))
                .animation(vm.binding.dragAnimation, value: dragOffset)
                .highPriorityGesture(
                    DragGesture()
                        .updating($dragOffset, body: { (value, state, _) in
                            state = value.translation.width
                        })
                        .onChanged({ value in
                            vm.onChangedDragGesture()
                        })
                        .onEnded({ value in
                            vm.updateCurrentIndex(dragGestureValue: value, bodyView: bodyView)
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.warning)
                        })
                )
            }
        }
    }
}

struct FriendsPostView: View {
    @EnvironmentObject var tabBar: HideTabBar
    @StateObject var vm: ListViewModel
    let postViewID:String
    var namespace: Namespace.ID
    let post: Post
    
    var body: some View {
        GeometryReader { postView in
            VStack {
                HStack(spacing: 5) {
                    Text("\(post.userID)")
                        Spacer()
                        Text("¥\(post.price)")
                    }
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                Spacer()
            }
            .background(
                KFImage.url(URL(string: post.images.first!))
                    .placeholder{ ProgressView() }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .mask {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .matchedGeometryEffect(id: "mask\(postViewID)", in: namespace)
            }
            .contentShape(RoundedRectangle(cornerRadius: 15))
            .onTapGesture {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    vm.binding.selectedPost = post
                    vm.binding.selectedIndex = postViewID
                    vm.binding.isShownPostDetail.toggle()
                    tabBar.isHidden = true
                }
            }
        }
        .matchedGeometryEffect(id: postViewID, in: namespace)
    }
}

struct ListFriendsView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        ListFriendsView(vm: ListViewModel(), namespace: namespace)
    }
}


