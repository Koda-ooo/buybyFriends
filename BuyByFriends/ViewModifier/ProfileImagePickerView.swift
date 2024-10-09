//
//  ProfileImagePickerView.swift
//  BuyByFriends
//
//  Created by KOTA TAKAHASHI on 2024/10/09.
//

import SwiftUI
import PhotosUI

struct ProfileImagePickerView: View {
    @Binding var profileImageURL: String
    @Binding var selectedItem: PhotosPickerItem?
    @State private var profileImage: Image?

    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: UIScreen.main.bounds.height*0.11,
                            height: UIScreen.main.bounds.height*0.11
                        )
                        .clipShape(Circle())
                } else {
                    AsyncImage(url: URL(string: profileImageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: UIScreen.main.bounds.height*0.11,
                                height: UIScreen.main.bounds.height*0.11
                            )
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .frame(
                                width: UIScreen.main.bounds.height*0.11,
                                height: UIScreen.main.bounds.height*0.11
                            )
                    }
                }

                Circle()
                    .fill(Color.black.opacity(0.4))
                    .frame(
                        width: UIScreen.main.bounds.height*0.11,
                        height: UIScreen.main.bounds.height*0.11
                    )

                Image(systemName: "pencil")
                    .foregroundColor(Asset.Colors.white.swiftUIColor)

            }
        }
        .padding(.vertical, 16)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    profileImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}
