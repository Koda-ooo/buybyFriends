//
//  EditPersonalInfoView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/08/20.
//

import SwiftUI

struct EditPersonalInfoView: View {
    @EnvironmentObject var path: Path
    @ObservedObject var vm: PurchaseViewModel
    
    static let rowHeight = 80.0
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            
            List {
                VStack(alignment: .leading, spacing: 12) {
                    Text("お届け先住所").bold()
                    VStack(alignment: .leading) {
                        Text(vm.binding.adress.postNumber)
                        Text(vm.binding.adress.prefecture+vm.binding.adress.city+vm.binding.adress.number)
                        Text(vm.binding.adress.buildingName)
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
                
                ForEach(PersonalInfo.allCases, id: \.self) { selected in
                    switch selected {
                    case .kanjiName:
                        VStack(alignment: .leading, spacing: 20) {
                            Text("氏名（漢字）").bold()
                            TextField("山田太郎", text: vm.$binding.adress.kanjiName)
                        }
                        .frame(height: EditShippingAdressView.rowHeight)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    case .kanaName:
                        VStack(alignment: .leading, spacing: 20) {
                            Text("氏名（カナ）").bold()
                            TextField("ヤマダタロウ", text: vm.$binding.adress.kanaName)
                        }
                        .frame(height: EditShippingAdressView.rowHeight)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    case .phoneNumber:
                        VStack(alignment: .leading, spacing: 20) {
                            Text("電話番号").bold()
                            TextField("000-0000-0000", text: vm.$binding.adress.phoneNumber)
                        }
                        .frame(height: EditShippingAdressView.rowHeight)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    case .email:
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Eメール").bold()
                            TextField("bbf@example.com", text: vm.$binding.adress.email)
                        }
                        .frame(height: EditShippingAdressView.rowHeight)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                }
            }
            .frame(height: 5*EditShippingAdressView.rowHeight + 50)
            .scrollDisabled(true)
            
            Spacer()
                .frame(height: 30)
            
            Button(action: {
                self.vm.input.startToSaveAdress.send()
                path.path.removeLast(2)
            }) {
                Text("登録する")
                    .frame(
                        width: UIScreen.main.bounds.width*0.4,
                        height: UIScreen.main.bounds.width*0.12
                    )
            }
            .foregroundColor(.white)
            .background(vm.output.isEnableRegisterButton ? Color.black:Color.gray)
            .bold()
            .cornerRadius(UIScreen.main.bounds.width*0.3/3)
            .disabled(!vm.output.isEnableRegisterButton)
            
            Spacer()
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("お届け先情報")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.path.path.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct EditPersonalInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditPersonalInfoView(vm: PurchaseViewModel())
    }
}


enum PersonalInfo: CaseIterable {
    case kanjiName
    case kanaName
    case phoneNumber
    case email
}
