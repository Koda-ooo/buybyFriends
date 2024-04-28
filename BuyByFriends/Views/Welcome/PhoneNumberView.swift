//
//  PhoneNumberView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI
import Combine

struct PhoneNumberView: View {
    @EnvironmentObject var path: Path
    @StateObject private var vm = PhoneNumberViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("電話番号を入力してください。")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(.black)
                .padding(.top, 30)
            
            Text("電話番号は会員登録のみに利用され、\n外部に公表されることは一切ございません。")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.black)
                .padding(.bottom, 30)
            
            VStack(spacing: 50) {
                HStack(spacing: 15){
                    Text("+81")
                        .font(.system(size: 20, weight: .light))
                        .padding(.leading, 20)
                        .foregroundColor(.black)
                    Text("|")
                        .font(.system(size: 50, weight: .thin))
                        .padding(.bottom, 5)
                        .foregroundColor(.gray)
                    TextField("000 0000 0000", text: vm.$binding.phoneNumber)
                        .font(.system(size: 27, weight: .medium))
                        .keyboardType(.phonePad)
                        .foregroundColor(.black)
                }
                .background(.white)
                .cornerRadius(5)
                
                Button(action: {
                    UIApplication.shared.closeKeyboard()
                    vm.input.startToSignUp.send()
                }) {
                    Text("認証コードを送信")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 20, weight: .medium))
                }
                .accentColor(Color.white)
                .background(!vm.output.isEnabledSingUpButton ? Color.gray:Color.black)
                .cornerRadius(.infinity)
                .disabled(!vm.output.isEnabledSingUpButton)
            }
            Spacer()
        }
        .frame(maxWidth: UIScreen.main.bounds.width*0.85)
        .background(Image("main")
            .edgesIgnoringSafeArea(.all)
        )
        .onChange(of: vm.output.isMovedVerificationCodeView) { _ in
            path.path.append(Destination.Welcome.verificationCode)
        }
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .navigationBarBackButtonHidden(true)
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

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
    }
}
