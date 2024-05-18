//
//  BirthDayView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI

struct BirthDayView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = BirthDayViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("生年月日を入力してください。")
                .font(.system(size: 20, weight: .black))
                .padding(.top, 30)

            DatePicker("", selection: vm.$binding.birthDay,
                       in: Date().addingTimeInterval(-60*60*24*365*100)...Date(),
                       displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())

            Button(action: {
                self.appState.session.userInfo.birthDay = vm.binding.birthDay
                path.path.append(Destination.UserInfo.profileImage)
            }) {
                Text("次へ")
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .font(.system(size: 20, weight: .medium))
            }
            .accentColor(Color.white)
            .background(Color.black)
            .cornerRadius(.infinity)
            .padding(.top, 100)
            Spacer()
        }
        .frame(maxWidth: UIScreen.main.bounds.width*0.85)
        .background(
            Asset.main.swiftUIImage
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
    }
}

struct BirthDayView_Previews: PreviewProvider {
    static var previews: some View {
        BirthDayView()
    }
}
