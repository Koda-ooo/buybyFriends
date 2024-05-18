//
//  WithdrawView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/03.
//

import SwiftUI

struct WithdrawView: View {
    @EnvironmentObject var path: Path
    @StateObject var vm = WithdrawViewModel()

    static let rowHeight: CGFloat = 68

    var body: some View {
        VStack(alignment: .leading) {
            Text("口座情報")
                .padding([.leading, .top])
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)

            List {
                HStack {
                    Text("銀行")
                    Spacer()
                    TextField("例）ヤマダタロウ銀行",
                              text: self.vm.$binding.withdraw.bankName)
                        .fixedSize()
                        .multilineTextAlignment(.trailing)
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                HStack {
                    Text("口座種別")
                    Spacer()
                    TextField("例）普通銀行",
                              text: self.vm.$binding.withdraw.bankAccountType)
                        .fixedSize()
                        .multilineTextAlignment(.trailing)
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                HStack {
                    Text("支店コード")
                    Spacer()
                    TextField("例）123（数字3桁）",
                              text: self.vm.$binding.withdraw.branchCode)
                        .fixedSize()
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                HStack {
                    Text("口座番号")
                    Spacer()
                    TextField("例）12345657（数字7桁）",
                              text: self.vm.$binding.withdraw.bankAccountNumber)
                        .fixedSize()
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                HStack {
                    Text("口座名義（セイ）")
                    Spacer()
                    TextField("例）ヤマモト",
                              text: self.vm.$binding.withdraw.firstName)
                        .fixedSize()
                        .multilineTextAlignment(.trailing)
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

                HStack {
                    Text("口座名義（メイ）")
                    Spacer()
                    TextField("例）リョウ",
                              text: self.vm.$binding.withdraw.lastName)
                        .fixedSize()
                        .multilineTextAlignment(.trailing)
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .frame(height: 6*WithdrawView.rowHeight)
            .scrollDisabled(true)

            Spacer()

            NavigationLink(value: vm.binding.withdraw) {
                Text("次へ")
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .font(.system(size: 16, weight: .medium))
            }
            .background(!vm.output.isEnabledNextButton ? Color.gray:Color.black)
            .foregroundColor(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 2)
            )
            .mask {
                RoundedRectangle(cornerRadius: 8)
            }
            .padding()
            .disabled(!vm.output.isEnabledNextButton)

            Spacer()

        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("振込先口座の入力")
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
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
    }
}

struct WithdrawView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawView()
    }
}
