//
//  WelcomeView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var path: Path

    var body: some View {
        NavigationStack(path: $path.path) {
            VStack(spacing: 20) {
                Spacer()
                Text("BuyByFriend")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                Spacer()
                NavigationLink(value: Destination.Welcome.phoneNumberVerification) {
                    Text("Get started")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .foregroundColor(Asset.Colors.white.swiftUIColor)
                }
                .background(Asset.Colors.jetBlack.swiftUIColor)
                .cornerRadius(.infinity)
                .padding(.horizontal, 30)

                VStack {
                    Text("本アプリでは「Get started」を押した時点で")
                        .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    HStack(spacing: 0) {
                        if let url = URL(string: "https://www.apple.com/") {
                            Link("利用規約", destination: url)
                        }
                        Text("と")
                            .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                        if let url = URL(string: "https://www.apple.com/") {
                            Link("プライバシーポリシー", destination: url)
                        }
                        Text("に同意いただいたことになります。")
                            .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                    }
                }
                .font(.system(size: 12, weight: .medium))
                .padding(.horizontal, 5)

                NavigationLink(value: Destination.Welcome.logIn) {
                    Text("ログイン")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                }
                .cornerRadius(.infinity)
                .padding(.horizontal, 30)
            }
            .font(.system(size: 20, weight: .heavy))
            .padding(.bottom, 30)
            .background(
                Asset.main.swiftUIImage
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Destination.Welcome.self) { value in
                switch value {
                case .phoneNumberVerification: PhoneNumberView()
                case .verificationCode: VerificationCodeView()
                case .finishSignUp: UsernameView()
                case .logIn: LogInView()
                case .finishLogIn: LogIn_VerificationCodeView()
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
