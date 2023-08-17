//
//  PostDetailView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/14.
//

import SwiftUI
import Kingfisher

struct PostDetailView: View {
    @EnvironmentObject var tabBar: HideTabBar
    @StateObject var vm = PostDetailViewModel()
    @Binding var isShownPostDetailView: Bool
    let index: String
    var namespace: Namespace.ID
    
    init(
        vm:PostDetailViewModel = PostDetailViewModel(),
        isShownPostDetailView: Binding<Bool>,
        post: Post,
        index: String,
        namespace: Namespace.ID
    ) {
        vm.binding.post = post
        self._isShownPostDetailView = isShownPostDetailView
        self.index = index
        self.namespace = namespace
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ScrollView(showsIndicators: false) {
                    cover
            }
            
            HStack(spacing: 10) {
                Button(action: {
                    print("tapped")
                }) {
                    if let imageURLString = vm.output.userInfo.profileImage {
                        KFImage.url(URL(string: imageURLString))
                            .resizable()
                            .placeholder {
                                ProgressView().foregroundColor(.gray)
                            }
                    }
                }
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 30, height: 30)
                Text(vm.binding.post.userID)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isShownPostDetailView.toggle()
                        tabBar.isHidden = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.bold))
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }.padding()
        }
        .mask {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .matchedGeometryEffect(id: "mask\(index)", in: namespace)
        }
    }
    
    var cover: some View {
        VStack(alignment: .leading,spacing: 10) {
            PostImagesView(images: vm.binding.post.images, index: index, namespace: namespace)
                .matchedGeometryEffect(id: index, in: namespace)
            
            HStack(spacing: 20) {
                CustomButton(
                    isFill: vm.$binding.favariteFlag,
                    imageName: "heart",
                    onTappedForAdd: self.vm.input.startToAddFavaritePosts.send,
                    onTappedForRemove: self.vm.input.startToRemoveFavaritePosts.send
                )
                
                Button(action: {
                    
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
                
                Spacer()
                
                CustomButton(
                    isFill: vm.$binding.bookmarkFlag,
                    imageName: "globe.europe.africa",
                    onTappedForAdd: self.vm.input.startToAddBookmarkPosts.send,
                    onTappedForRemove: self.vm.input.startToRemoveBookmarkPosts.send
                )
                
                Button(action: {
                    
                }){
                    Image(systemName: "ellipsis")
                }
            }
            .padding(.horizontal, 20)
            .font(.system(size: 23))
            .foregroundColor(.black)
            
            Text(vm.binding.post.explain)
                .padding(.horizontal, 10)
            
            Divider()
            
            ForEach(PostInformation.allCases, id: \.self) { info in
                switch info {
                case .category: PostDetailInformationView(title: info.rawValue, result: vm.binding.post.category)
                case .brand: PostDetailInformationView(title: info.rawValue, result: vm.binding.post.brand)
                case .size: PostDetailInformationView(title: info.rawValue, result: vm.binding.post.size)
                case .condition: PostDetailInformationView(title: info.rawValue, result: vm.binding.post.condition)
                case .price: EmptyView()
                }
            }
            .font(.system(size: 15))
            .padding(.horizontal, 10)
            
            Divider()
            
            Spacer()
        }
        .navigationBarHidden(true)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Text("¥ \(vm.binding.post.price)")
                    Spacer()
                    Button(action: {
                        //購入手続きへの導線
                        vm.input.startToMovePurchaseView.send()
                    }) {
                        Text("購入する")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .frame(width: 120, height: 30)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(5)
                }
            }
        }
        .onAppear {
            vm.input.startToFetchUserInfo.send(vm.binding.post.userUID)
        }
        .navigationDestination(isPresented: vm.$binding.isMovedPurchaseView) {
            PurchaseView(post: vm.binding.post)
        }
    }
    
}

struct PostImagesView: View {
    var images: [String]
    var index: String
    var namespace: Namespace.ID
    
    var body: some View {
        TabView {
            ForEach(self.images, id: \.self){ image in
                ZStack(alignment: .center) {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color.gray)
                        KFImage.url(URL(string: image))
                            .resizable()
                            .placeholder {
                                ProgressView().foregroundColor(.gray)
                            }
                            .scaledToFit()
                    }
                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width/3*4)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
    }
}

struct PostDetailInformationView: View {
    var title: String
    var result: String
    
    var body: some View {
        HStack {
            Text(title)
                .bold()
            Spacer()
            Text(result)
        }
        .padding(.bottom, 10)
    }
}

struct CustomButton: View {
    
    @Binding var isFill: Bool
    private var imageName: String
    private var onTappedForAdd: (() -> Void)?
    private var onTappedForRemove: (() -> Void)?
    
    init(
        isFill: Binding<Bool>,
        imageName: String,
        onTappedForAdd: (() -> Void)? = nil,
        onTappedForRemove: (() -> Void)? = nil
    ) {
        self._isFill = isFill
        self.imageName = imageName
        self.onTappedForAdd = onTappedForAdd
        self.onTappedForRemove = onTappedForRemove
    }
    
    var body: some View {
        configureLikeImage()
    }
    
    private func configureLikeImage() -> AnyView {
        var _imageName = self.imageName
        if self._isFill.wrappedValue {
            _imageName = "\(self.imageName).fill"
        }
        return AnyView(
            Image(systemName: _imageName)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    if self._isFill.wrappedValue {
                        self.onTappedForRemove?()
                    } else {
                        self.onTappedForAdd?()
                    }
                }
        )
    }
}


struct PostDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    @State static var isShownPostDetailView = true
    static var previews: some View {
        PostDetailView(isShownPostDetailView: $isShownPostDetailView, post: Post(dic: [:]), index: "", namespace: namespace)
    }
}
