//
//  PostView.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/17.
//

import SwiftUI
import Combine
import PhotosUI

struct PostView: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @StateObject var vm = PostViewModel()
    @State var path: [String] = []
    @FocusState private var focusedField: Bool

    static var config: PHPickerConfiguration {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 10
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        return config
    }

    var gesture: some Gesture {
            DragGesture()
                .onChanged { value in
                    if value.translation.height != 0 {
                        self.focusedField = false
                    }
                }
        }

    let others = ["売上金受け取り方法", "商品受け渡し方法"]

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center) {
                        if vm.$binding.images.isEmpty {
                            Button(action: {
                                vm.input.isCameraButtonTapped.send()
                            }) {
                                Asset.Icons.camera.swiftUIImage
                                    .padding()
                                    .frame(width: 65, height: 65)
                                    .overlay(RoundedRectangle(cornerRadius: 2)
                                        .stroke(style: StrokeStyle(dash: [8, 7])))
                                    .foregroundColor(Asset.Colors.stormGreen.swiftUIColor)
                                    .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: {
                                vm.input.isSelectImagesButtonTapped.send()
                            }) {
                                Asset.Icons.gallery.swiftUIImage
                                    .padding()
                                    .frame(width: 65, height: 65)
                                    .overlay(RoundedRectangle(cornerRadius: 2)
                                        .stroke(style: StrokeStyle(dash: [8, 7])))
                                    .foregroundColor(Asset.Colors.stormGreen.swiftUIColor)
                                    .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())

                            ForEach(2..<10) { _ in
                                Text("")
                                    .padding()
                                    .font(.system(size: 20))
                                    .frame(width: 65, height: 65)
                                    .overlay(RoundedRectangle(cornerRadius: 2)
                                        .stroke(style: StrokeStyle(dash: [8, 7])))
                                    .foregroundColor(Color.gray)
                                    .background(Color.white)
                            }
                        } else {
                            ForEach(0..<vm.$binding.images.count, id: \.self) { i in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: vm.binding.images[i])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 65, height: 65)
                                        .clipped()
                                    ZStack {
                                        Circle()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.white)
                                        Button(action: { vm.binding.images.remove(at: i) }) {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .offset(x: 5, y: -5)
                                }
                            }
                            if vm.$binding.images.count < 10 {
                                Button(action: {
                                    vm.input.isCameraButtonTapped.send()
                                }) {
                                    Asset.Icons.camera.swiftUIImage
                                        .padding()
                                        .frame(width: 65, height: 65)
                                        .overlay(RoundedRectangle(cornerRadius: 2)
                                            .stroke(style: StrokeStyle(dash: [8, 7])))
                                        .foregroundColor(Asset.Colors.stormGreen.swiftUIColor)
                                        .background(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())

                                Button(action: {
                                    vm.input.isSelectImagesButtonTapped.send()
                                }) {
                                    Asset.Icons.gallery.swiftUIImage
                                        .padding()
                                        .frame(width: 65, height: 65)
                                        .overlay(RoundedRectangle(cornerRadius: 2)
                                            .stroke(style: StrokeStyle(dash: [8, 7])))
                                        .foregroundColor(Asset.Colors.stormGreen.swiftUIColor)
                                        .background(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())

                                if vm.$binding.images.count < 9 {
                                    ForEach(vm.$binding.images.count..<8, id: \.self) { _ in
                                        Text("")
                                            .padding()
                                            .font(.system(size: 20))
                                            .frame(width: 65, height: 65)
                                            .overlay(RoundedRectangle(cornerRadius: 2)
                                                .stroke(style: StrokeStyle(dash: [8, 7])))
                                            .foregroundColor(Color.gray)
                                            .background(Color.white)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.init(top: 5, leading: 1, bottom: 5, trailing: 1))
                    .listRowSeparator(.hidden)
                }
                Text("商品の説明")
                    .listRowSeparator(.hidden)
                    .padding(.top, 20)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                ZStack(alignment: .topLeading) {
                    TextEditor(text: vm.$binding.explain)
                        .focused($focusedField)
                        .padding(.horizontal, -4)
                        .frame(minHeight: 200)
                    if vm.binding.explain.isEmpty {
                        Text("色、素材、重さ、定価、注意点など\n\n例）去年、原宿の古着屋さんで買ったTシャツ！\nスター・トレックの事は知らなかったけど、ビジュが良くて一目惚れした❤️\nTシャツなんてなんぼあってもいいですからね〜\n\nたぶん、10,000円ぐらいで買ってサイズはL\nTシャツは一年中着れるしこれはガチでおすすめ\nピンホールあるけどそれも古着の醍醐味でしょ😥")
                            .foregroundColor(Color(uiColor: .placeholderText))
                            .font(.system(size: 13))
                            .kerning(1)
                            .lineSpacing(3)
                            .padding(.vertical, 8)
                            .allowsHitTesting(false)
                    }
                }
                .listRowSeparator(.visible)

                Text("商品の情報")
                    .listRowSeparator(.hidden)
                    .padding(.top, 20)
                    .padding(.bottom, -5)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                ForEach(PostInformation.allCases, id: \.self) { info in
                    if info == PostInformation.category {
                        NavigationLink(value: info.rawValue) {
                            HStack {
                                Text(info.rawValue)
                                Spacer()
                                Text(vm.binding.category)
                            }
                        }
                    } else {
                        HStack {
                            Button(action: {
                                // 商品の各情報入力への導線（ハーフモーダルで実装予定）
                                vm.input.isInsertInformationButtonTapped.send(info)
                            }) {
                                switch info {
                                case .category: EmptyView()
                                case .brand: PostInformationView(title: info.rawValue, result: vm.binding.brand)
                                case .size: PostInformationView(title: info.rawValue, result: vm.binding.size)
                                case .condition: PostInformationView(title: info.rawValue, result: vm.binding.condition)
                                case .price:
                                    ZStack {
                                        HStack {
                                            Text("価格")
                                            Spacer()
                                            Image(systemName: "yensign")
                                                .foregroundColor(.gray)
                                            if let price = vm.output.intPrice {
                                                Text("\(price)")
                                            }

                                        }
                                        TextField("", text: vm.$binding.price)
                                            .focused($focusedField)
                                            .foregroundColor(.clear)
                                            .keyboardType(.numberPad)
                                            .multilineTextAlignment(.trailing)
                                            .onReceive(Just(vm.binding.price), perform: { _ in
                                                if 6 < vm.binding.price.count {
                                                    vm.binding.price = String(vm.binding.price.prefix(6))
                                                }
                                            })
                                    }
                                    .listRowSeparator(.visible)
                                }
                            }
                        }
                    }
                }
                .accentColor(.black)
                .font(.system(size: 15))
                .frame(height: 37)
                .listRowSeparator(.visible)

                Text("その他")
                    .listRowSeparator(.hidden)
                    .padding(.top, 20)
                    .padding(.bottom, -5)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Asset.Colors.jetBlack.swiftUIColor)
                ForEach(others, id: \.self) { other in
                    HStack {
                        Button(action: {
                            // その他の各情報入力への導線（ハーフモーダルで実装予定）
                        }) {
                            HStack {
                                Text(other)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .accentColor(.black)
                    .font(.system(size: 15))
                }
                .frame(height: 37)
                .listRowSeparator(.visible)
            }
            .navigationBarTitle("出品の情報を入力", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("×")
                            .accentColor(.black)
                            .font(.system(size: 40))
                    })

                }

                ToolbarItem(placement: .bottomBar) {
                    HStack(spacing: 20) {
                        Button(action: {
                            // 下書き保存への導線
                        }) {
                            Text("下書きに保存する　　")
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .font(.system(size: 15, weight: .medium))
                        }
                        .accentColor(Color.black)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 1))
                        .disabled(vm.output.isCreatDraftButtonEnabled)

                        Button(action: {
                            // 出品への導線
                            vm.binding.post.images = []
                            vm.binding.post.explain = vm.binding.explain
                            vm.binding.post.category = vm.binding.category
                            vm.binding.post.brand = vm.binding.brand
                            vm.binding.post.size = vm.binding.size
                            vm.binding.post.condition = vm.binding.condition
                            vm.binding.post.price = vm.output.intPrice ?? 0
                            vm.binding.post.userID = appState.session.userInfo.userID
                            vm.binding.post.userUID = appState.session.userInfo.id
                            vm.binding.post.id = UUID().uuidString
                            vm.input.isCreatPostButtonTapped.send()
                        }) {
                            Text("出品する　　　　　　")
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .background(vm.output.isCreatPostButtonEnabled ? Color.gray:Color.black)
                        .cornerRadius(10)
                        .disabled(vm.output.isCreatPostButtonEnabled)

                    }
                    .padding(.top, 10)
                }
            }
            .navigationDestination(for: String.self) { _ in
                SelectCategoryView(vm: self.vm, path: $path)
            }
            .gesture(self.gesture)
        }
        .listStyle(.inset)
        .sheet(isPresented: vm.$binding.isPHPickerShown) {
            SwiftUIPHPicker(configuration: PostView.config) { results in
                vm.input.isImagesSelected.send(results)
            }
        }
        .sheet(isPresented: vm.$binding.isCameraShown) {
            ImagePicker(sourceType: .camera, selectedImage: vm.$binding.takePicture)
        }
        .sheet(isPresented: vm.$binding.isInsertBrandViewShown) {
            SelectBrandView(vm: self.vm).presentationDetents([.medium])
        }
        .sheet(isPresented: vm.$binding.isInsertClothesSizeViewShown) {
            SelectClothesSizeView(vm: self.vm).presentationDetents([.medium])
        }
        .sheet(isPresented: vm.$binding.isInsertShoesSizeViewShown) {
            SelectShoesSizeView(vm: self.vm)
        }
        .sheet(isPresented: vm.$binding.isInsertConditionViewShown) {
            SelectConditionView(vm: self.vm).presentationDetents([.medium])
        }
        .fullScreenCover(isPresented: vm.$binding.isFinishPostViewShown) {
            FinishPostView(appState: self.appState, vm: self.vm)
        }
    }

}

struct PostInformationView: View {
    var title: String
    var result: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(result)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

struct PostView_Previews: PreviewProvider {

    static var previews: some View {
        PostView()
    }
}
