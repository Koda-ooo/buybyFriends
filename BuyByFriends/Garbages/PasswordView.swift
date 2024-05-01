//
//  PasswordView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI

struct PasswordView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = PasswordViewModel()
    
    @FocusState  var focusText: Bool
    @FocusState  var focusSecure: Bool
    @State  var show: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30){
            Text("パスワードを入力してください。")
                .font(.system(size: 20, weight: .medium))
                .padding(.top, 30)
            
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("pass word", text: vm.$binding.password)
                        .focused($focusText)
                        .opacity(show ? 1 : 0)
                    
                    SecureField("pass word", text: vm.$binding.password)
                        .focused($focusSecure)
                        .opacity(show ? 0 : 1)
                    
                    Button(action: {
                        show.toggle()
                        if show {
                            focusText = true
                        } else {
                            focusSecure = true
                        }
                    }, label: {
                        Image(systemName: self.show ? "eye.slash.fill" : "eye.fill")
                            .padding()
                            .font(.system(size: 15))
                        
                    })
                }
            }
                .padding()
                .padding(.leading, 15)
                .font(.system(size: 27, weight: .medium))
                .keyboardType(.alphabet)
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(5)
            
            Button(action: {
            }) {
                Text("次へ")
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .font(.system(size: 20, weight: .medium))
            }
            .accentColor(Color.black)
            .background(!vm.output.isPasswordButtonEnabled ? Color.gray:Color.yellow)
            .cornerRadius(.infinity)
            .disabled(!vm.output.isPasswordButtonEnabled)
            .padding(.top, 100)
            Spacer()
        }
        .frame(maxWidth: UIScreen.main.bounds.width*0.85)
        .background(
            Asset.main.swiftUIImage
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
