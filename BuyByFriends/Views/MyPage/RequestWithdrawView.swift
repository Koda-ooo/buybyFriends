//
//  RequestWithdrawView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/07/05.
//

import SwiftUI
import Combine

struct RequestWithdrawView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = RequestWithdrawViewModel()
    var withdraw: Withdraw
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                HStack {
                    Text("現在の残高")
                    Spacer()
                    Text("¥ \(appState.session.userInfo.budget)")
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                ZStack {
                    HStack {
                        Text("振込申請金額")
                        Spacer()
                        Image(systemName:"yensign")
                            .foregroundColor(.gray)
                        if let price = vm.output.requestMoney {
                            Text("\(price)")
                        }
                        
                    }
                    TextField("", text: vm.$binding.requestMoney)
                        .foregroundColor(.clear)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .onReceive(Just(vm.binding.requestMoney), perform: { _ in
                            if 6 < vm.binding.requestMoney.count {
                                vm.binding.requestMoney = String(vm.binding.requestMoney.prefix(6))
                            }
                            if vm.output.requestMoney ?? 0 > appState.session.userInfo.budget {
                                vm.binding.requestMoney = String(appState.session.userInfo.budget)
                            }
                        })
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
            }
            .frame(height: 2*WithdrawView.rowHeight)
            .scrollDisabled(true)
            .padding(.top, 20)
            
            Text("お振込手数料として200円かかります。\nお振込が完了するまで5営業日程度をいただいております。")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
                .frame(height: WithdrawView.rowHeight)
                .padding(.leading)
            
            List {
                HStack {
                    Text("振込手数料")
                    Spacer()
                    Text("¥ 200")
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                HStack {
                    Text("振込金額")
                    Spacer()
                    if let money = self.vm.output.requestMoney {
                        Text("¥ \(money - 200)")
                    }
                }
                .frame(height: WithdrawView.rowHeight)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
            }
            .frame(height: 2*WithdrawView.rowHeight)
            .scrollDisabled(true)
            
            Button(action: {
                UIApplication.shared.closeKeyboard()
                path.path.removeLast(2)
            }) {
                Text("次へ")
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(!vm.output.isEnabledRequestWithdrawButton ? Color.gray:Color.black)
            .foregroundColor(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 2)
            )
            .mask {
                RoundedRectangle(cornerRadius: 8)
            }
            .padding()
            .disabled(!vm.output.isEnabledRequestWithdrawButton)
            
            Spacer()
            
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("振込申請金額を入力")
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
        .onAppear {
            vm.binding.withdraw = withdraw
        }
    }
}

struct RequestWithdrawView_Previews: PreviewProvider {
    static var previews: some View {
        RequestWithdrawView(withdraw: Withdraw(dic: [:]))
    }
}
