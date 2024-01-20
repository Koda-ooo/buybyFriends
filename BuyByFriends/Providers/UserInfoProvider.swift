//
//  UserInfoProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/05/21.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

final class UserInfoProvider: UserInfoProviderObject {
    
    func fetchUserInfo(id: String) -> AnyPublisher<UserInfo, Error> {
        return Future<UserInfo, Error> { promise in
            Firestore.firestore().collection("UserInfos").document(id).getDocument { (document, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    return
                }
                guard let document = document, let dic = document.data() else {
                    return promise(.success(UserInfo(dic: [:])))
                }
                promise(.success(UserInfo(dic: dic)))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchUserInfoo(id: String) -> AnyPublisher<UserInfo?, Error> {
        return Future<UserInfo?, Error> { promise in
            Firestore.firestore().collection("UserInfos").document(id).getDocument { (document, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    return
                }
                guard let document = document, let dic = document.data() else {
                    return promise(.success(nil))
                }
                promise(.success(UserInfo(dic: dic)))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchUserInfos(userID: String) -> AnyPublisher<[UserInfo], Error> {
        var userInfo = [UserInfo]()
        let searchUserID = userID.trimmingCharacters(in: .whitespaces)
        return Future<[UserInfo], Error> { promise in
            if searchUserID == "" { return }
            Firestore.firestore().collection("UserInfos")
                .order(by: "userID")
                .start(at: [searchUserID])
                .end(at: [searchUserID + "\u{f8ff}"])
                .limit(to: 50)
                .getDocuments { (documents, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    return
                }
                guard let documents = documents else {
                    print("該当ユーザーの情報が存在しません")
                    return
                }
                for document in documents.documents {
                    let dic = UserInfo(dic: document.data())
                    userInfo.append(dic)
                }
                promise(.success(userInfo))
                
            }
        }.eraseToAnyPublisher()
    }
    
    func observeUserInfos(query: Query) -> AnyPublisher<[UserInfo], ListError> {
        return Publishers.QuerySnapshotPublisher(query: query)
            .flatMap { snapshot -> AnyPublisher<[UserInfo], ListError> in
                do {
                    let userInfos = try snapshot.documents.compactMap {
                        try $0.data(as: UserInfo.self)
                    }
                    return Just(userInfos)
                        .setFailureType(to: ListError.self)
                        .eraseToAnyPublisher()
                } catch {
                    print("check: Parsing error")
                    return Fail(error: .default(description: "Parsing error"))
                        .eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    func uploadProfileImage(image: Data) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            if image.count == 0 {
                promise(.success("https://firebasestorage.googleapis.com/v0/b/buybyfriends-b3354.appspot.com/o/profile_image%2Fdownload20230403222715.png?alt=media&token=baf55d38-2060-4577-be0f-4725cbcfb4e4"))
                return
            }
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
            
            storageRef.putData(image, metadata: nil) { (metadata, err) in
                if let err = err {
                    print("Firestorageへの保存に失敗しました。\(err)")
                    return
                }
                storageRef.downloadURL { (url, err) in
                    if let err = err {
                        print("Firestorageからのダウンロードに失敗しました。\(err)")
                        return
                    }
                    guard let urlString = url?.absoluteString else { return }
                    promise(.success(urlString))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func uploadUserInfo(userInfo: UserInfo, imageURL: String) -> AnyPublisher<Bool,Error> {
        return Future<Bool,Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let saveDocument = Firestore.firestore().collection("UserInfos").document(uid)
            let uploadList: [String: Any] = [
                "id": uid,
                "name": userInfo.name,
                "userID": userInfo.userID,
                "birthDay": userInfo.birthDay,
                "profileImage": imageURL,
                "inventoryList": userInfo.inventoryList,
                "selfIntroduction": "",
                "instagramID": "",
                "budget": 0,
                "createdAt": Timestamp(),
                "fcmToken": UserDefaults.standard.string(forKey: "fcmToken") ?? "",
                "favoritePosts": [],
                "bookmarkPosts": []
            ]
            
            saveDocument.setData(
                uploadList
            ){ (err) in
                if let err = err {
                    print("Firestoreへの保存に失敗しました。\(err)")
                    promise(.failure(err.self))
                }
                print("Firestoreへの保存に成功しました。")
                promise(.success(true))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateBudget(mount: Int) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("UserInfos").document(uid)
            let updateList: [String: Any] = [
                "budget": FieldValue.increment(Int64(mount))
            ]
            
            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateInventory(inventory: [Inventory]) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("UserInfos").document(uid)
            let updateList: [String: Any] = [
                "inventoryList": inventory.filter { $0.selected }.map { $0.name }
            ]
            
            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func addBookmarkPosts(postID: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("UserInfos").document(uid)
            let updateList: [String: Any] = [
                "bookmarkPosts": FieldValue.arrayUnion([postID])
            ]
            
            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success((true)))
            }
        }.eraseToAnyPublisher()
    }
    
    func removeBookmarkPosts(postID: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("UserInfos").document(uid)
            let updateList: [String: Any] = [
                "bookmarkPosts": FieldValue.arrayRemove([postID])
            ]
            
            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success((true)))
            }
        }.eraseToAnyPublisher()
    }
    
    func addFavaritePosts(postID: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("UserInfos").document(uid)
            let updateList: [String: Any] = [
                "favaritePosts": FieldValue.arrayUnion([postID])
            ]
            
            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success((true)))
            }
        }.eraseToAnyPublisher()
    }
    
    func removeFavaritePosts(postID: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("UserInfos").document(uid)
            let updateList: [String: Any] = [
                "favaritePosts": FieldValue.arrayRemove([postID])
            ]
            
            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success((true)))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveWishList(genre: InventoryGenre, text: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let document = Firestore.firestore().collection("UserInfos").document(uid)
            let updateList: [String: Any] = [
                "wishList": ["\(genre.rawValue)": text]
            ]
            
            document.updateData(updateList) { err in
                if let err = err {
                    return promise(.failure(err.self))
                }
                promise(.success((true)))
            }
        }.eraseToAnyPublisher()
    }
}
