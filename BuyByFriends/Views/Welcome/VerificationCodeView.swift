//
//  VerificationCodeView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI

struct VerificationCodeView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = VerificationCodeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30){
            Text("認証コードを入力してください。")
                .font(.system(size: 20, weight: .black))
                .padding(.top, 30)
            
            TextField("123456", text: vm.$binding.verificationCode)
                .padding()
                .padding(.leading, 15)
                .font(.system(size: 27, weight: .medium))
                .keyboardType(.phonePad)
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(5)
            
            Text("認証コードが届くまで60秒ほどお待ちください")
                .font(.system(size: 12, weight: .medium))
                .padding(.top, -10)
            
            // 同意して始める
            Button(action: {
                UIApplication.shared.closeKeyboard()
                vm.input.signinTapped.send()
            }) {
                Text("同意して始める")
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .font(.system(size: 20, weight: .medium))
            }
            .accentColor(Color.white)
            .background(!vm.output.isEnabledSignInButton ? Color.gray:Color.black)
            .cornerRadius(.infinity)
            .disabled(!vm.output.isEnabledSignInButton)
            Spacer()
        }
        .frame(maxWidth: UIScreen.main.bounds.width*0.85)
        .background(
            Asset.main.swiftUIImage
                .edgesIgnoringSafeArea(.all)
        )
        .onChange(of: vm.output.isMovedUsernameView) { _ in
            path.path.removeLast(path.path.count)
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

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView()
    }
}
