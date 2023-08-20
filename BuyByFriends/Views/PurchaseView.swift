//
//  PurchaseView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/14.
//

import SwiftUI
import Kingfisher
import Stripe
import StripePaymentsUI
import StripeCardScan
import StripePaymentSheet

struct PurchaseView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = PurchaseViewModel()
    let post: Post
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                if let imageURLString = post.images.first {
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
                    Text(post.category)
                    Text(post.explain)
                    Text("¥\(post.price)")
                        .padding(.top, 10)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            Button(action: {
                vm.binding.isMovedInsertAdressView.toggle()
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("お届け先情報").bold()
                        if self.vm.binding.adress.postNumber != "" {
                            Text(self.vm.binding.adress.postNumber)
                        } else {
                            Text("住所を追加する")
                        }
                    }
                    Spacer()
                    Image(systemName:  "chevron.right")
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 70)

            Button(action: {
                vm.input.startToCreatePaymentIntent.send(post)
            }) {
                Text("決済へ進む")
                    .frame(
                        width: UIScreen.main.bounds.width*0.4,
                        height: UIScreen.main.bounds.width*0.12
                    )
            }
            .foregroundColor(.white)
            .background(.black)
            .bold()
            .cornerRadius(5)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .font(.system(size: 15))
        .navigationBarBackButtonHidden(true)
        .navigationTitle("購入手続き")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                })  {
                    Image(systemName:  "chevron.left")
                        .accentColor(.black)
                }
                
            }
        }
        .navigationDestination(for: Destination.Purchase.self) { selected in
            switch selected {
            case .editAdress:
                EditShippingAdressView(vm: self.vm)
            case .editPersonalInfo:
                EditPersonalInfoView(vm: self.vm)
            case .finishPurchase:
                FinishPurchaseView(post: post)
            }
        }
        .onChange(of: vm.binding.isMovedFinishPurchaseView) { _ in
            path.path.append(Destination.Purchase.finishPurchase)
        }
        .onChange(of: vm.binding.isMovedInsertAdressView) { _ in
            path.path.append(Destination.Purchase.editAdress)
        }
        .paymentSheet(
            isPresented: vm.$binding.isPresentedPaymentSheet,
            paymentSheet: vm.binding.paymentSheet
        ) { result in
            switch result {
            case .completed:
                vm.input.startToUpdatePost.send((postID: post.id, buyerID: appState.session.userInfo.id))
                vm.input.startToCreateDelivery.send(post)
            case .canceled:
                print("canceled")
            case .failed(error: let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

struct PurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseView(post: Post(dic: [:]))
    }
}
