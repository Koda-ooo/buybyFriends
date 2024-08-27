//
//  LogInView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/21.
//

import SwiftUI
import Combine

struct LogInView: View {
    @EnvironmentObject var path: Path
    @StateObject private var vm = LogInViewModel()

    var body: some View {
        ZStack {
            Asset.Colors.white.swiftUIColor
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("電話番号を入力してください。")
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    .font(.system(size: 20, weight: .black))
                    .padding(.top, 30)

                Text("BuyByFriends で快適に友達との売り買いを楽しむために電話番号入力をして本人確認をしましょう。")
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    .font(.system(size: 15, weight: .medium))
                    .padding(.bottom, 30)

                VStack(spacing: 50) {
                    HStack(spacing: 15) {
                        Text("+81")
                            .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                            .font(.system(size: 20, weight: .light))
                            .padding(.leading, 20)
                            .foregroundColor(.black)
                        Text("|")
                            .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                            .font(.system(size: 50, weight: .thin))
                            .padding(.bottom, 5)
                            .foregroundColor(.gray)
                        TextField("000 0000 0000", text: vm.$binding.phoneNumber)
                            .font(.system(size: 27, weight: .medium))
                            .keyboardType(.phonePad)
                            .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    }
                    .background(Asset.Colors.lightGray.swiftUIColor)
                    .cornerRadius(12)

                    Button(action: {
                        UIApplication.shared.closeKeyboard()
                        vm.input.startToLogIn.send()
                    }) {
                        Text("認証コードを送信")
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .font(.system(size: 20, weight: .medium))
                    }
                    .accentColor(Color.white)
                    .background(!vm.output.isEnabledLogInButton ? Color.gray:Color.black)
                    .cornerRadius(.infinity)
                    .disabled(!vm.output.isEnabledLogInButton)
                }
                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.width*0.85)
            .onChange(of: vm.output.isMovedVerificationCodeView) { _ in
                path.path.append(Destination.Welcome.finishLogIn)
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
                            .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    }
                }
        }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
            .environmentObject(Path())
    }
}
