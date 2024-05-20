//
//  UsernameView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI

struct UsernameView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = UsernameViewModel()

    var body: some View {
        NavigationStack(path: $path.path) {
            VStack(alignment: .leading, spacing: 30) {
                Text("名前を入力してください。")
                    .font(.system(size: 20, weight: .black))
                    .padding(.top, 80)

                TextField("Your name", text: vm.$binding.username)
                    .padding()
                    .padding(.leading, 15)
                    .font(.system(size: 27, weight: .medium))
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(5)

                Button(action: {
                    UIApplication.shared.closeKeyboard()
                    appState.session.userInfo.name = vm.binding.username
                    path.path.append(Destination.UserInfo.userID)
                }) {
                    Text("次へ")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 20, weight: .medium))
                }
                .accentColor(Color.white)
                .background(!vm.output.isEnabledNextButton ? Color.gray:Color.black)
                .cornerRadius(.infinity)
                .disabled(!vm.output.isEnabledNextButton)
                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.width*0.85)
            .background(
                Asset.main.swiftUIImage
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: Destination.UserInfo.self) { destination in
                switch destination {
                case .userID: UserIDVIew()
                case .birthDay: BirthDayView()
                case .profileImage: ProfileImageView()
                case .inventoryList: InventoryListView()
                }
            }
            .onTapGesture {
                UIApplication.shared.closeKeyboard()
            }
        }
    }
}

struct UsernameView_Previews: PreviewProvider {
    static var previews: some View {
        UsernameView()
    }
}
