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
            VStack(alignment: .leading, spacing: 16) {
                Text("電話番号を入力してください")
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 68)

                Text("BuyByFriends で快適に友達との売り買いを楽しむために電話番号入力をして本人確認をしましょう。")
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.bottom, 24)

                VStack(spacing: 50) {
                    HStack {
                        Text("+81")
                            .font(.system(size: 18, weight: .medium))
                            .padding(.leading, 24)
                            .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                        Text("|")
                            .font(.system(size: 50, weight: .thin))
                            .padding(.bottom, 5)
                            .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                        TextField("000 0000 0000", text: vm.$binding.phoneNumber)
                            .font(.system(size: 24, weight: .medium))
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
                            .foregroundColor(!vm.output.isEnabledLogInButton ? Asset.Colors.white.swiftUIColor:Asset.Colors.jetBlack.swiftUIColor)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .accentColor(Color.white)
                    .background(!vm.output.isEnabledLogInButton ? Asset.Colors.silver.swiftUIColor:Asset.Colors.chromeYellow.swiftUIColor)
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
