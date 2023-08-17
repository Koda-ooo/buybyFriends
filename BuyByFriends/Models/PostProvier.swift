//
//  PostProvier.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/30.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

final class PostProvider: PostProviderProtocol {
    private let db = Firestore.firestore()
    
    func fetchSelectedImages(images: [PHPickerResult]) -> Future<[UIImage], Error> {
        return Future<[UIImage], Error> { promise in
            var results: [UIImage] = []
            var count: Int = 0
            
            for image in images {
                let itemProvider = image.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (uiImage, error) in
                        if let uiImage = uiImage as? UIImage {
                            DispatchQueue.main.async {
                                results.append(uiImage)
                                count += 1
                                if count == images.count {
                                    promise(.success(results))
                                }
                            }
                        }
                        if let error = error {
                            promise(.failure(error.self))
                        }
                    }
                }
            }
        }
    }
    
    func createImageURL(post: Post, images: [UIImage]) -> Future<Post, Error> {
        return Future<Post, Error> { promise in
            var imagesURL = [String]()
            var newpost = post
            
            for image in images {
                guard let uploadImage = image.jpegData(compressionQuality: 0.1) else { return }
                let fileName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("post_image").child(fileName)
                
                storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
                    if let err = err {
                        print("Firestorageへの保存に失敗しました。\(err)")
                        promise(.failure(err.self))
                    }
                    storageRef.downloadURL { (url, err) in
                        if let err = err {
                            print("Firestorageからのダウンロードに失敗しました。\(err)")
                            promise(.failure(err.self))
                        }
                        
                        guard let urlString = url?.absoluteString else { return }
                        imagesURL.append(urlString)
                        
                        if images.count == imagesURL.count {
                            newpost.images = imagesURL
                            promise(.success(newpost))
                        }
                    }
                }
            }
        }
    }
    
    func savePostToFirestore(post: Post) -> AnyPublisher<Bool, Error>{
        return Future<Bool, Error> { promise in
            do {
                _ = try self.db.collection("Posts").document(post.id).setData(from: post)
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func observePosts(query: Query) -> AnyPublisher<[Post], ListError> {
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[Post], ListError> in
                do {
                    let posts = try snapshot.documents.compactMap {
                        try $0.data(as: Post.self)
                    }
                    return Just(posts)
                        .setFailureType(to: ListError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
}

