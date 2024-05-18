//
//  NotificationTodoView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/25.
//

import UIKit
import SwiftUI
import Kingfisher

struct NotificationTodoView: View {
    @StateObject var vm: NotificationViewModel
    var deliveries: [Delivery]
    var uid: String

    init(
        vm: NotificationViewModel,
        deliveries: [Delivery],
        uid: String
    ) {
        if !deliveries.isEmpty {
            vm.input.startToFetchUserInfos.send(deliveries.flatMap { [$0.buyerID, $0.sellerID]})
            vm.input.startToFetchPosts.send(deliveries.map { $0.postID })
        }
        _vm = StateObject(wrappedValue: vm)
        self.deliveries = deliveries
        self.uid = uid
    }

    var body: some View {
        ForEach(deliveries) { delivery in
            TodoView(vm: self.vm, delivery: delivery, uid: self.uid)
        }.padding(.horizontal)
    }
}

struct NotificationTodoView_Previews: PreviewProvider {
    static var deliveries = [Delivery(dic: [:])]

    static var previews: some View {
        NotificationTodoView(vm: NotificationViewModel(), deliveries: deliveries, uid: "")
    }
}

struct TodoView: View {
    @StateObject var vm: NotificationViewModel
    var delivery: Delivery
    var uid: String
    var post: Post?
    var seller: UserInfo?
    var buyer: UserInfo?
    var isSeller: Bool?
    @State var isShownAdressView: Bool = false
    @State var isShownSentAlert: Bool = false
    @State var isShownReceivedAlert: Bool = false
    @State var isShownFinishAlert: Bool = false

    init(vm: NotificationViewModel, delivery: Delivery, uid: String) {
        _vm = StateObject(wrappedValue: vm)

        self.delivery = delivery
        self.uid = uid
        self.post = vm.binding.posts.first(where: { $0.id == self.delivery.postID })
        self.seller = vm.binding.userInfos.first(where: { $0.id == self.delivery.sellerID })
        self.buyer = vm.binding.userInfos.first(where: { $0.id == self.delivery.buyerID })
        self.isSeller = self.proveBuyerSeller()
    }

    var body: some View {
        VStack {
            Text(self.configureTodoText())
                .bold()

            HStack(spacing: 20) {
                if let imageURLString = self.post?.images.first {
                    KFImage.url(URL(string: imageURLString))
                        .resizable()
                        .placeholder {
                            ProgressView().foregroundColor(.gray)
                        }
                        .frame(
                            width: UIScreen.main.bounds.size.width*0.35,
                            height: UIScreen.main.bounds.size.width*0.35
                        )
                        .cornerRadius(5)
                }

                VStack(alignment: .leading) {
                    Text(self.post?.category ?? "")
                    Text(self.post?.explain ?? "")
                    Text("¥\(self.post?.price ?? 0)")
                        .padding(.top, 10)
                        .foregroundColor(.gray)
                }
                Spacer()
            }

            if isShownAdressButton() {
                Button(action: {
                    self.isShownAdressView.toggle()
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("お届け先情報").bold()
                            Text(self.delivery.adress.postNumber)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 70)
            }

            if isShownTodoButton() {
                Button(action: {
                    self.configureTodoButtonAction()
                }) {
                    Text(self.configureTodoButtonText())
                }
                .frame(
                    width: UIScreen.main.bounds.width*0.4,
                    height: UIScreen.main.bounds.width*0.12
                )
                .foregroundColor(.white)
                .background(Color.black)
                .bold()
                .cornerRadius(5)
            }

        }
        .alert("商品を発送しましたか？", isPresented: self.$isShownSentAlert) {
            Button("戻る") {
                self.isShownSentAlert = false
            }
            Button("はい") {
                self.vm.input.startToUpdateIsSentFlag.send(delivery)
                self.isShownSentAlert = false
            }
        }
        .alert("商品を受け取りましたか？", isPresented: self.$isShownReceivedAlert) {
            Button("戻る") {
                self.isShownSentAlert = false
            }
            Button("はい") {
                self.vm.input.startToUpdateIsReceivedFlag.send(delivery)
                self.isShownSentAlert = false
            }
        }
        .alert("売上金を受け取りますか？", isPresented: self.$isShownFinishAlert) {
            Button("戻る") {
                self.isShownSentAlert = false
            }
            Button("はい") {
                self.isShownSentAlert = false
                self.vm.input.startToUpdateIsFinishFlag.send((delivery: delivery, post: post ?? Post(dic: [:])))
            }
        }
        .sheet(isPresented: self.$isShownAdressView) {
            VStack {
                Spacer()
                    .frame(height: 30)

                Text("お届け先情報")
                    .bold()

                List {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("お届け先住所").bold()
                        VStack(alignment: .leading) {
                            Text(delivery.adress.postNumber)
                            Text(delivery.adress.prefecture+delivery.adress.city+delivery.adress.number)
                            Text(delivery.adress.buildingName)
                        }
                        .foregroundColor(.gray)
                    }
                    .frame(height: EditShippingAdressView.rowHeight + 30)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden, edges: .top)
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 20,
                            trailing: 0
                        )
                    )
                    VStack(alignment: .leading, spacing: 20) {
                        Text("氏名（漢字）").bold()
                        Text(delivery.adress.kanjiName)
                            .foregroundColor(.gray)
                    }
                    .frame(height: EditShippingAdressView.rowHeight)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    VStack(alignment: .leading, spacing: 20) {
                        Text("氏名（カナ）").bold()
                        Text(delivery.adress.kanaName)
                            .foregroundColor(.gray)
                    }
                    .frame(height: EditShippingAdressView.rowHeight)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
            }
            .listStyle(.plain)
            .scrollDisabled(true)
            .presentationDetents([.large, .height(400), .fraction(0.5)])
        }
    }

    private func configureTodoText() -> String {
        guard let isSeller = isSeller else { return "読み込み失敗" }
        var text = ""

        switch delivery.isSent {
        case true:
            switch delivery.isReceived {
            case true:
                switch isSeller {
                case true:
                    text = "売上金を受け取りましょう"
                case false:
                    text = "売上金の受け取り待ちです"
                }
            case false:
                switch isSeller {
                case true:
                    text = "商品配送中です。"
                case false:
                    text = "商品が発送されました！商品が到着したら受け取り完了ボタンを押してください。"
                }
            }
        case false:
            switch isSeller {
            case true:
                text = "商品を発送し、発送完了ボタンを押してください"
            case false:
                text = "商品が発送されるまでお待ちください"
            }
        }
        return text
    }

    private func isShownAdressButton() -> Bool {
        return delivery.isSent == false && uid == seller?.id
    }

    private func isShownTodoButton() -> Bool {
        switch delivery.isSent {
        case true:
            switch delivery.isReceived {
            case true:
                return delivery.isFinish == false && uid == seller?.id
            case false:
                return uid == buyer?.id
            }
        case false:
            return uid == seller?.id
        }
    }

    private func configureTodoButtonAction() {
        switch delivery.isSent {
        case true:
            switch delivery.isReceived {
            case true:
                self.isShownFinishAlert = true
            case false:
                self.isShownReceivedAlert = true
            }
        case false:
            self.isShownSentAlert = true
        }
    }

    private func configureTodoButtonText() -> String {
        var text: String

        switch delivery.isSent {
        case true:
            switch delivery.isReceived {
            case true:
                text = "売上金を受け取る"
            case false:
                text = "受け取り完了"
            }
        case false:
            text = "発送完了"
        }
        return text
    }

    /// Seller == true, Buyer == false
    private func proveBuyerSeller() -> Bool? {
        if self.uid == delivery.sellerID {
            return true
        } else if self.uid == delivery.buyerID {
            return false
        }
        return nil
    }
}
