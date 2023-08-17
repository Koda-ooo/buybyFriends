//
//  EditShippingAdressView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/12.
//

import SwiftUI

struct EditShippingAdressView: View {
//    @StateObject var vm: EditShippingAdressViewModel
    @State var text: String = ""
    
//    init(vm: EditShippingAdressViewModel = EditShippingAdressViewModel()) {
//        _vm = StateObject(wrappedValue: vm)
//    }
    
    
    var body: some View {
        List {
            ForEach(ShippingAdress.allCases, id: \.self) { selected in
                HStack {
                    switch selected {
                    case .postNumber:
                        VStack(spacing: 20) {
                            Text("郵便番号")
                            TextField("半角数字7桁で入力", text: $text)
                        }
                    case .prefecture:
                        VStack(spacing: 20) {
                            Text("郵便番号")
                            TextField("半角数字7桁で入力", text: $text)
                        }
                    case .city:
                        VStack(spacing: 20) {
                            Text("郵便番号")
                            TextField("半角数字7桁で入力", text: $text)
                        }
                    case .number:
                        VStack(spacing: 20) {
                            Text("郵便番号")
                            TextField("半角数字7桁で入力", text: $text)
                        }
                    case .buildingName:
                        VStack(spacing: 20) {
                            Text("郵便番号")
                            TextField("半角数字7桁で入力", text: $text)
                        }
                    }
                }.padding(.vertical, 8)
            }
        }
    }
}

struct EditShippingAdressView_Previews: PreviewProvider {
    static var previews: some View {
        EditShippingAdressView()
    }
}


enum ShippingAdress: CaseIterable {
    case postNumber
    case prefecture
    case city
    case number
    case buildingName
}
