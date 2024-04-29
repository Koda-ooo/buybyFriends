//
//  FinishPostView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/07.
//

import SwiftUI

struct FinishPostView: View {
    @ObservedObject var appState: AppState
    @ObservedObject var vm: PostViewModel
    
    var body: some View {
        VStack(spacing: 20){
            Spacer()
            Text("出品が完了しました🎉")
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
                    Image(uiImage: (vm.binding.images.first ?? UIImage()))
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width-100,
                               height:UIScreen.main.bounds.width-100)
                    Text(appState.session.userInfo.userID)
                    HStack {
                        Text("¥")
                        if let price = vm.output.intPrice {
                            Text("\(price)")
                        }
                    }
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
                    shareToInstagramStory()
                }) {
                    Asset.Sns.instagram.swiftUIImage
                }
                Button(action: {
                    shareOnLINE()
                }) {
                    Asset.Sns.line.swiftUIImage
                }
                Button(action: {
                    shareOnTwitter()
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
                let scenes = UIApplication.shared.connectedScenes
                let windowScenes = scenes.first as? UIWindowScene
                let rootVC = windowScenes?.keyWindow?.rootViewController
                
                rootVC?.dismiss(animated: true, completion: nil)
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
    }
    
    func shareToInstagramStory() {
        guard let imageData = vm.binding.images.first else { return }
        let urlToBuyByFriends = "https://twitter.com"
        _ = InstaStories.Shared.post(
            bgImage: UIImage(named: "noimage") ?? UIImage(),
            stickerImage:imageData,
            contentURL: urlToBuyByFriends
        )
    }
    
    private func shareOnTwitter() {
        let text = "" //ツイート本文
        let hashTag = "#BuyByFriends" //ハッシュタグ
        let urlToBuyByFriends = "" // アプリのURL
        let completedText = text + "\n" + hashTag + "\n" + "\n" + urlToBuyByFriends
        
        //作成したテキストをエンコード
        let encodedText = completedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //エンコードしたテキストをURLに繋げ、URLを開いてツイート画面を表示させる
        if let encodedText = encodedText,
           let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareOnLINE() {
        let urlScheme: String = "https://line.me/R/share?text="
        let text = "" //メッセージ本文
        let urlToBuyByFriends = "" // アプリのURL
        let completedText = urlScheme + text + "\n" + urlToBuyByFriends
        
        //作成したテキストをエンコード
        let encodedURL = completedText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: encodedURL!)
        guard let openUrl = url else { return }
        UIApplication.shared.open(openUrl, options: .init(), completionHandler: nil)
    }
    
}

struct FinishPostView_Previews: PreviewProvider {
    
    static var previews: some View {
        FinishPostView(appState: AppState(), vm: PostViewModel())
    }
}
