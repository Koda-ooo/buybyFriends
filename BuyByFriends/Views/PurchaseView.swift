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
    @EnvironmentObject var path: Path
    @StateObject var vm: PurchaseViewModel
    @Binding var isShownPostDetailView: Bool

    init(vm: PurchaseViewModel = PurchaseViewModel(),
         post: Post,
         isShownPostDetailView: Binding<Bool>
    ) {
        vm.input.startToGetAdress.send()
        vm.binding.post = post
        _vm = StateObject(wrappedValue: vm)
        _isShownPostDetailView = isShownPostDetailView
    }

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                if let imageURLString = self.vm.binding.post.images.first {
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
                    Text(self.vm.binding.post.category)
                    Text(self.vm.binding.post.explain)
                    Text("¥\(self.vm.binding.post.price)")
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
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 70)

            Button(action: {
                vm.input.startToCreatePaymentIntent.send()
            }) {
                Text("決済へ進む")
                    .frame(
                        width: UIScreen.main.bounds.width*0.4,
                        height: UIScreen.main.bounds.width*0.12
                    )
            }
            .foregroundColor(.white)
            .background(vm.output.isEnablePurchaseButton ? Color.black:Color.gray)
            .bold()
            .cornerRadius(5)
            .disabled(!vm.output.isEnablePurchaseButton)

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
                    self.path.path.removeLast()
                }) {
                    Image(systemName: "chevron.left")
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
                FinishPurchaseView(isShownPostDetailView: self.$isShownPostDetailView, post: self.vm.binding.post)
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
                vm.input.startToUpdatePost.send()
                vm.input.startToCreateDelivery.send()
            case .canceled:
                print("canceled")
            case .failed(error: let error):
                print(error.localizedDescription)
            }
        }
    }

}

struct PurchaseView_Previews: PreviewProvider {
    @State static var isShownPostDetailView = true
    static var previews: some View {
        PurchaseView(post: Post(dic: [:]), isShownPostDetailView: $isShownPostDetailView)
    }
}
