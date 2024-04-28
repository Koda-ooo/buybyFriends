//
//  UserIDVIew.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI

struct UserIDVIew: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = UserIDViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30){
            Text("ユーザー名を入力してください。")
                .font(.system(size: 20, weight: .black))
                .foregroundColor(.black)
                .padding(.top, 30)
            
            HStack{
                Text("@")
                    .padding(.leading, 20)
                TextField("Username", text: vm.$binding.userID)
                    .padding()
                    .keyboardType(.alphabet)
            }
            .font(.system(size: 27, weight: .medium))
            .frame(maxWidth: UIScreen.main.bounds.width*0.85)
            .background(.white)
            .cornerRadius(5)
            
            Button(action: {
                UIApplication.shared.closeKeyboard()
                appState.session.userInfo.userID = vm.binding.userID
                path.path.append(Destination.UserInfo.birthDay)
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
        .background(Image("main")
            .edgesIgnoringSafeArea(.all)
        )
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
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
    }
}

struct UserIDVIew_Previews: PreviewProvider {
    static var previews: some View {
        UserIDVIew()
    }
}
