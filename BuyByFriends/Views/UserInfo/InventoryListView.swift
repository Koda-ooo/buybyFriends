//
//  InventoryListView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/08.
//

import SwiftUI

struct InventoryListView: View {
    @EnvironmentObject var path: Path
    @EnvironmentObject var appState: AppState
    @StateObject var vm = InventoryViewModel()
    
    init() {
        UINavigationBar.appearance().barTintColor = UIColor.clear
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading ,spacing: 30) { 
                Text("持ち物を教えてください。")
                    .font(.system(size: 20, weight: .black))
                
                GenreView(
                    datas: InventoryGenre.names(),
                    spacing: 10) { genre in
                        Text(genre.debugDescription)
                        
//                        FlexibleView(
//                            data:  vm.output.inventoryList,
//                            spacing: 10,
//                            alignment: .leading
//                        ) { item in
//                            Button(action: {
//                                vm.input.inventoryListTapped.send(item)
//                            }) {
//                                HStack {
//                                    Text(item.name)
//                                        .font(.system(size: 13))
//                                        .bold()
//                                    if item.selected {
//                                        Image(systemName: "checkmark")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 10, height: 10)
//                                    } else {
//                                        Image(systemName: "plus")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 10, height: 10)
//                                    }
//                                }
//                                .padding(.horizontal, 16)
//                                .padding(.vertical, 8)
//                                .foregroundColor(item.selected ? .white : .black)
//                                .background(item.selected ? .black : .gray)
//                                .cornerRadius(10)
//                            }
//                        }
                    }
            }
            
            Button(action: {
                appState.session.userInfo.inventoryList = vm.binding.selectedInventoryList
                vm.binding.userInfo = appState.session.userInfo
                vm.input.startButByFriends.send()
            }) {
                Text("Start BuyByFriends")
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .font(.system(size: 20, weight: .bold))
            }
            .accentColor(Color.white)
            .background(Color.black)
            .cornerRadius(.infinity)
            .padding(.top, 50)
            .padding(.trailing, 30)
        }
        .padding(.leading, 20)
        .background(Image("main")
            .edgesIgnoringSafeArea(.all)
        )
        .onChange(of: vm.output.isFinishedUploadUserInfo) { result in
            appState.session.isLoggedIn = result
            path.path.removeLast(path.path.count)
        }
        .onAppear {
            vm.convertUIImageToData(image: appState.session.userImage)
            vm.input.inventoryListViewDidLoad.send()
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
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

struct InventoryListView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryListView()
    }
}
