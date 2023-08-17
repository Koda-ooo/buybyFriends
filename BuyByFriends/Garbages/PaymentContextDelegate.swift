//
//  PaymentContextDelegate.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/16.
//

import Foundation
import Stripe
import SwiftUI

class PaymentContextDelegate: NSObject, STPPaymentContextDelegate, ObservableObject {

    @Published var paymentMethodButtonTitle = "Select Payment Method"
    @Published var showAlert = false
    @Published var message = ""

    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        //   let title: String
        var message: String

        switch status {
        case .success:

            //    title = "Success!"
            message = "Thank you for your purchase."
            showAlert = true
            self.message = message
        case .error:
            
            //   title = "Error"
            message = error?.localizedDescription ?? ""
            showAlert = true
            self.message = message
        case .userCancellation:
            return
        @unknown default:
            fatalError("Something really bad happened....")
        }
    }

    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {

        paymentMethodButtonTitle = paymentContext.selectedPaymentOption?.label ?? "Select Payment Method"

        //updating the selected shipping method


        //            shippingMethodButtonTitle = paymentContext.selectedShippingMethod?.label ?? "Select Shipping Method"
        //
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
    }
}
