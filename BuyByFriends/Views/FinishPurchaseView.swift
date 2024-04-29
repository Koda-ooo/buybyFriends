//
//  FinishPurchaseView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/18.
//

import SwiftUI

struct FinishPurchaseView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var tabBar: HideTabBar
    @ObservedObject var vm = FinishPurchaseViewModel()
    @Binding var isShownPostDetailView: Bool
    let post: Post
    
    var body: some View {
        VStack(spacing: 20){
            Spacer()
            Text("購入が完了しました🎉")
                .font(.system(size: 20, weight: .bold))
            Spacer()
            
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .frame (
                        width: UIScreen.main.bounds.width-80,
                        height: UIScreen.main.bounds.width-40
                    )
                    .cornerRadius(3)
                VStack(alignment: .leading) {
                    if let imageURLString = post.images.first {
                        AsyncImage(url: URL(string: imageURLString)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: UIScreen.main.bounds.width-100,
                               height:UIScreen.main.bounds.width-100)
                    }
                    Text(post.userID)
                    Text("¥ \(post.price)")
                }
            }
            .font(.system(size: 15, weight: .bold))
            .frame(maxWidth: .infinity, minHeight: 70)
            .padding(.horizontal, 50)
            .cornerRadius(0)
            .shadow(color: .gray, radius: 3)
            Spacer()
            HStack(spacing: 15) {
                Button(action: {
                    vm.convertURLToData(url: post.images.first!)
                }) {
                    Asset.Sns.instagram.swiftUIImage
                }
                Button(action: {
                    vm.input.startToShareToLine.send()
                }) {
                    Asset.Sns.line.swiftUIImage
                }
                Button(action: {
                    vm.input.startToShareToTwitter.send()
                }) {
                    Asset.Sns.twitter.swiftUIImage
                }
                Button(action: {
                    
                }) {
                    Asset.Sns.link.swiftUIImage
                }
                Button(action: {
                    
                }) {
                    Asset.Sns.etc.swiftUIImage
                }
            }
            .frame(maxWidth: .infinity, minHeight: 70)
            
            Spacer()
            
            Button(action: {
                isShownPostDetailView.toggle()
                path.path.removeLast(path.path.count)
                tabBar.isHidden = false
            }) {
                Text("ホームへ戻る")
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
            }
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))
            .padding(.horizontal, 30)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

struct FinishPurchaseView_Previews: PreviewProvider {
    @State static var isShownPostDetailView = true
    
    static var previews: some View {
        FinishPurchaseView(isShownPostDetailView: $isShownPostDetailView, post: Post(dic: [:]))
    }
}
