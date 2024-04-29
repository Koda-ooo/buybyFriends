//
//  ProfileImageView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI

struct ProfileImageView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = ProfileImageViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("プロフィール写真を選択してください")
                .font(.system(size: 20, weight: .black))
                .padding(.bottom, 20)
            
            HStack {
                if let uiImage = vm.binding.profileImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(1,contentMode: .fit)
                        .clipShape(Circle())
                        .frame(
                            width: UIScreen.main.bounds.width*0.5,
                            height: UIScreen.main.bounds.width*0.5
                        )
                } else {
                    Image("noimage")
                        .resizable()
                        .aspectRatio(1,contentMode: .fit)
                        .clipShape(Circle())
                        .frame(
                            width: UIScreen.main.bounds.width*0.5,
                            height: UIScreen.main.bounds.width*0.5
                        )
                }
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            HStack(spacing: 10) {
                Button(action: {
                    vm.input.imagePickerTapped.send()
                }) {
                    Text("ライブラリから\n選択")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 17, weight: .medium))
                }
                .accentColor(Color.white)
                .background(Color.black)
                .cornerRadius(.infinity)
                
                Button(action: {
                    vm.input.selfImagePickerTapped.send()
                }) {
                    Text("写真を撮る")
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .font(.system(size: 17, weight: .medium))
                }
                .accentColor(Color.white)
                .background(Color.black)
                .cornerRadius(.infinity)
            }
            .padding(.bottom, 10)
            
            Button(action: {
                self.appState.session.userImage = vm.binding.profileImage!
                path.path.append(Destination.UserInfo.inventoryList)
            }) {
                Text("次へ")
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .font(.system(size: 20, weight: .medium))
            }
            .accentColor(Color.white)
            .background(Color.black)
            .cornerRadius(.infinity)
        }
        .frame(maxWidth: UIScreen.main.bounds.width*0.85)
        .padding(.top, 40)
        .padding(.bottom, 80)
        .sheet(isPresented: vm.$binding.isShownImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: vm.$binding.profileImage)
        }
        
        .sheet(isPresented: vm.$binding.isShownSelfImagePickerShown) {
            ImagePicker(sourceType: .camera, selectedImage: vm.$binding.profileImage)
        }
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

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView()
    }
}
