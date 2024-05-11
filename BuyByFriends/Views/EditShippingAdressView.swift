//
//  EditShippingAdressView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/12.
//

import SwiftUI

struct EditShippingAdressView: View {
    @EnvironmentObject var path: Path
    @ObservedObject var vm: PurchaseViewModel

    static let rowHeight = 80.0

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            List {
                ForEach(ShippingAdress.allCases, id: \.self) { selected in
                    switch selected {
                    case .postNumber:
                        VStack(alignment: .leading, spacing: 20) {
                            Text("郵便番号").bold()
                            TextField("半角数字7桁で入力", text: vm.$binding.adress.postNumber)
                                .keyboardType(.phonePad)
                        }
                        .frame(height: EditShippingAdressView.rowHeight)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .listRowSeparator(.hidden, edges: .top)

                    case .prefecture:
                        VStack(alignment: .leading, spacing: 20) {
                            Text("都道府県").bold()
                            TextField("都道府県を入力", text: vm.$binding.adress.prefecture)
                        }
                        .frame(height: EditShippingAdressView.rowHeight)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    case .city:
                        VStack(alignment: .leading, spacing: 20) {
                            Text("市町村").bold()
                            TextField("市町村を入力", text: vm.$binding.adress.city)
                        }
                        .frame(height: EditShippingAdressView.rowHeight)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    case .number:
                        VStack(alignment: .leading, spacing: 20) {
                            Text("番地").bold()
                            TextField("番地を入力", text: vm.$binding.adress.number)
                        }
                        .frame(height: EditShippingAdressView.rowHeight)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                    case .buildingName:
                        VStack(alignment: .leading, spacing: 20) {
                            Text("建物名").bold()
                            TextField("建物名を入力（任意）", text: vm.$binding.adress.buildingName)
                        }
                        .frame(height: EditShippingAdressView.rowHeight)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                }
            }
            .frame(height: 5*EditShippingAdressView.rowHeight)
            .scrollDisabled(true)

            Spacer()
                .frame(height: 30)

            Button(action: {
                self.vm.binding.isMovedInsertPersonalInfo.toggle()
            }) {
                Text("次へ")
                    .frame(
                        width: UIScreen.main.bounds.width*0.3,
                        height: UIScreen.main.bounds.width*0.12
                    )
            }
            .foregroundColor(.white)
            .background(vm.output.isEnableNextButton ? Color.black:Color.gray)
            .bold()
            .cornerRadius(UIScreen.main.bounds.width*0.3/3)
            .disabled(!vm.output.isEnableNextButton)

            Spacer()
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("お届け先情報")
        .onChange(of: vm.binding.isMovedInsertPersonalInfo) { _ in
            self.path.path.append(Destination.Purchase.editPersonalInfo)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    path.path.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct EditShippingAdressView_Previews: PreviewProvider {
    static var previews: some View {
        EditShippingAdressView(vm: PurchaseViewModel())
    }
}

enum ShippingAdress: CaseIterable {
    case postNumber
    case prefecture
    case city
    case number
    case buildingName
}
