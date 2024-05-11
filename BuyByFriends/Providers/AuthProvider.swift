//
//  AuthProvider.swift
//  BuyByFriends
//
//  Created by 鈴木登也 on 2023/04/19.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class AuthProvider: AuthProviderObject {
    func observeAuthChange() -> AnyPublisher<User?, Never> {
        Publishers.AuthPublisher().eraseToAnyPublisher()
    }

    func signUpByPhoneNumber(phoneNumber: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            if phoneNumber != "" {
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber("+81"+phoneNumber, uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                            print("check: \(error.localizedDescription)")
                            self.setErrorMessage(error)
                            return
                        }
                        // ユーザーデフォルトにverificationIDをセット
                        if let verificationID = verificationID {
                            UserDefaults.standard.set(verificationID, forKey: "verificationID")
                            print("success")
                            promise(.success((true)))
                        }
                    }
            } else {
                print("fail")
                promise(.failure(AuthError.invalidIdOrPassword))
            }
        }.eraseToAnyPublisher()
    }

    func signInByPhoneNumber(verificationCode: String) -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            let verificationID = UserDefaults.standard.object(forKey: "verificationID") as? String
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: verificationCode)

            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(AuthError.invalidCredential))
                    return
                }
                if let _ = authResult, let uid = authResult?.user.uid {
                    print("success")
                    promise(.success(uid))
                } else {
                    print("fail")
                    promise(.failure(AuthError.invalidCredential))
                }
            }
        }.eraseToAnyPublisher()
    }

    func signOut() -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(true))
            } catch let error as NSError {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func setErrorMessage(_ error: Error?) {
        if let error = error as NSError? {
            if let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .accountExistsWithDifferentCredential:
                    print("0 - アカウントのリンクが必要であることを示します。")
                case .adminRestrictedOperation:
                    print("1- 操作が管理者によって制限されていることを示します。")
                case .appNotAuthorized:
                    print("2- アプリが提供された API キーで Firebase Authentication を使用する権限がないことを示します。")
                case .appNotVerified:
                    print("3- 電話番号認証中に Firebase でアプリを確認できなかったことを示します。")
                case .appVerificationUserInteractionFailure:
                    print("4- アプリの検証フロー中に一般的なエラーが発生したことを示します。")
                case .captchaCheckFailed:
                    print("5- reCAPTCHA トークンが無効であることを示します。")
                case .credentialAlreadyInUse:
                    print("6- 既に別の Firebase アカウントにリンクされている資格情報にリンクしようとしていることを示します")
                case .customTokenMismatch:
                    print("7- サービス アカウントと API キーが異なるプロジェクトに属していることを示します。")
                case.dynamicLinkNotActivated:
                    print("8- Firebase Dynamic Link がアクティブ化されていないことを示します。")
                case .emailAlreadyInUse:
                    print("9- サインアップの試行に使用された電子メールが既に使用されていることを示します。")
                case .emailChangeNeedsVerification:
                    print("10- 検証済みの電子メールを変更する必要があることを示します。")
                case .expiredActionCode:
                    print("11- OOB コードの有効期限が切れていることを示します。")
                case .gameKitNotLinked:
                    print("12- Game Center サインインを試行する前に、GameKit フレームワークがリンクされていないことを示します。")
                case .internalError:
                    print("13- 内部エラーが発生したことを示します。")
                case .invalidActionCode:
                    print("15- OOB コードが無効であることを示します。")
                case .invalidAPIKey:
                    print("15- リクエストで無効な API キーが指定されたことを示します。")
                case .invalidAppCredential:
                    print("16- verifyClient リクエストで無効な APNS デバイス トークンが使用されたことを示します。")
                case .invalidClientID:
                    print("17- Web フローの呼び出しに使用された clientID が無効であることを示します。")
                case .invalidContinueURI:
                    print("18- 続行 URI で指定されたドメインが無効であることを示します。")
                case .invalidCredential:
                    print("19- IDP トークンまたは requestUri が無効であることを示します。")
                case .invalidCustomToken:
                    print("20- カスタム トークンの検証エラーを示します。")
                case .invalidDynamicLinkDomain:
                    print("21- 使用されている Firebase Dynamic Link ドメインが構成されていないか、現在のプロジェクトで許可されていないことを示しています。")
                case .invalidEmail:
                    print("22- 電子メールが無効であることを示します。")
                case.invalidMessagePayload:
                    print("23- 「パスワード リセット メールの送信」試行中に、ペイロードに無効なパラメーターがあることを示します。")
                case .invalidMultiFactorSession:
                    print("24- 多要素セッションが無効であることを示します。")
                case .invalidPhoneNumber:
                    print("25- verifyPhoneNumber:completion: への呼び出しで無効な電話番号が提供されたことを示します。")
                case .invalidProviderID:
                    print("26- Web 操作の指定されたプロバイダー ID が無効な場合のエラー コードを表します。")
                case .invalidRecipientEmail:
                    print("27- 受信者の電子メールが無効であることを示します。")
                case .invalidSender:
                    print("28- 「パスワード リセット メールの送信」試行中に送信者のメールが無効であることを示します。")
                case .invalidUserToken:
                    print("29- ユーザーが保存した認証資格情報が無効であることを示しています。ユーザーは再度サインインする必要があります。")
                case .invalidVerificationCode:
                    print("30- verifyPhoneNumber リクエストで無効な確認コードが使用されたことを示します。")
                case .invalidVerificationID:
                    print("31- verifyPhoneNumber リクエストで無効な検証 ID が使用されたことを示します。")
                case.keychainError:
                    print("32- キーチェーンへのアクセス試行中にエラーが発生したことを示します。")
                case .localPlayerNotAuthenticated:
                    print("33- Game Center サインインを試行する前に、ローカル プレイヤーが認証されなかったことを示します。")
                case .maximumSecondFactorCountExceeded:
                    print("34 - 最大の第 2 要素カウントを超えたことを示します。")
                case .malformedJWT:
                    print("35- JWT が正しく解析できなかった場合に発生します。JWT 解析プロセスのどのステップが失敗したかを示す根本的なエラーが付随する場合があります。")
                case .missingAndroidPackageName:
                    print("36- androidInstallApp フラグが true に設定されている場合、android パッケージ名が欠落していることを示します。")
                case .missingAppCredential:
                    print("37- APNS デバイス トークンが verifyClient 要求にないことを示します。")
                case .missingAppToken:
                    print("38- APNs デバイス トークンを取得できなかったことを示します。アプリがリモート通知を正しく設定していないか、アプリのデリゲート スウィズリングが無効になっている場合、APNs デバイス トークンを FIRAuth に転送できない可能性があります。")
                case.missingContinueURI:
                    print("39- 続行 URI が必要なバックエンドへのリクエストで提供されなかったことを示します。")
                case .missingClientIdentifier:
                    print("40- クライアント識別子が欠落している場合のエラーを示します。")
                case .missingEmail:
                    print("41- メールアドレスが必要でしたが、提供されなかったことを示します。")
                case .missingIosBundleID:
                    print("42- iOS App Store ID が提供されている場合、iOS バンドル ID が欠落していることを示します。")
                case.missingMultiFactorSession:
                    print("43- 多要素セッションが欠落していることを示します。")
                case.missingOrInvalidNonce:
                    print("44- nonce がないか無効であることを示します。")
                case.missingPhoneNumber:
                    print("45- verifyPhoneNumber:completion への呼び出しで電話番号が提供されなかったことを示します。")
                case.missingVerificationCode:
                    print("46- 電話認証資格情報が空の確認コードで作成されたことを示します。")
                case .missingVerificationID:
                    print("47- 電話認証資格情報が空の検証 ID で作成されたことを示します。")
                case.missingMultiFactorInfo:
                    print("48- 多要素情報が欠落していることを示します。")
                case.multiFactorInfoNotFound:
                    print("49- 多要素情報が見つからないことを示します。")
                case .networkError:
                    print("50- ネットワーク エラーが発生したことを示します タイムアウト、中断された接続、到達不能なホストなど。これらのタイプのエラーは、多くの場合、再試行で回復可能です。NSError.userInfo ディクショナリの NSUnderlyingError フィールドには、発生したエラーが含まれます。")
                case.noSuchProvider:
                    print("51- リンクされていないプロバイダーをリンク解除しようとしていることを示します。")
                case.notificationNotForwarded:
                    print("52- アプリが FIRAuth へのリモート通知の転送に失敗したことを示します。")
                case .nullUser:
                    print("53- 操作の引数として null 以外のユーザーが予期されていたが、null ユーザーが指定されたことを示します。")
                case .operationNotAllowed:
                    print("54- 管理者が指定された ID プロバイダーでのサインインを無効にしたことを示します。")
                case .providerAlreadyLinked:
                    print("55- アカウントが既にリンクされているプロバイダをリンクしようとしていることを示します。")
                case .quotaExceeded:
                    print("56- 特定のプロジェクトの SMS メッセージのクォータが超過したことを示します。")
                case.rejectedCredential:
                    print("57- 資格情報が形式に誤りがあるか、または不一致であるため、資格情報が拒否されたことを示します。")
                case .requiresRecentLogin:
                    print("58- ユーザーがサインイン後 5 分以上メールまたはパスワードの変更を試みたことを示します。")
                case .secondFactorAlreadyEnrolled:
                    print("59- 2 番目の要素が既に登録されていることを示します。")
                case .secondFactorRequired:
                    print("60- サインインには 2 番目の要素が必要であることを示します。")
                case .sessionExpired:
                    print("61- SMS コードの有効期限が切れたことを示します。")
                case .tooManyRequests:
                    print("62 - サーバー メソッドに対して行われた要求が多すぎることを示します。")
                case .unauthorizedDomain:
                    print("63- 続行 URL で指定されたドメインが Firebase コンソールでホワイトリストに登録されていないことを示します。")
                case .unsupportedFirstFactor:
                    print("64- 最初の要素がサポートされていないことを示します。")
                case.unverifiedEmail:
                    print("65- 確認のために電子メールが必要であることを示します。")
                case .userDisabled:
                    print("66- サーバー上でユーザーのアカウントが無効になっていることを示します。")
                case.userMismatch:
                    print("67- 現在のユーザーではないユーザーで再認証しようとしたことを示します。")
                case.userNotFound:
                    print("68 - ユーザー アカウントが見つからなかったことを示します。")
                case .userTokenExpired:
                    print("69- 保存されたトークンの有効期限が切れていることを示します。たとえば、ユーザーが別のデバイスでアカウント パスワードを変更した可能性があります。ユーザーは、この要求を行ったデバイスで再度サインインする必要があります。")
                case.weakPassword:
                    print("70 - 弱すぎると考えられるパスワードを設定しようとしていることを示します。")
                case .webContextAlreadyPresented:
                    print("71- 既に提示されている Web コンテキストに対して、新しい Web コンテキストを提示しようとしたことを示します。")
                case .webContextCancelled:
                    print("72- URL 表示がユーザーによって途中でキャンセルされたことを示します。")
                case .webInternalError:
                    print("73- SFSafariViewController または WKWebView 内で内部エラーが発生したことを示します。")
                case .webNetworkRequestFailed:
                    print("74- SFSafariViewController または WKWebView 内のネットワーク要求が失敗したことを示します。")
                case .wrongPassword:
                    print("75 - ユーザーが間違ったパスワードでサインインしようとしたことを示します。")
                case .webSignInUserInteractionFailure:
                    print("76- Web サインイン フロー中の一般的なエラーを示します。")
                default:
                    print("77- 不明なエラーが発生しました")
                }
            }
        }
    }

}
