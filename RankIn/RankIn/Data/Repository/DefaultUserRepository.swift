//
//  DefaultUserRepository.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import Alamofire
import RxSwift

final class DefaultUserRepository: UserRepository {
    
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func appleLogin(appleLoginModel: AppleLoginModel) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            self.session.request(
                RankInAPI.appleLogin(
                    appleLoginDTO: AppleLoginDTO(
                        identityToken: appleLoginModel.identityToken,
                        authorizationCode: appleLoginModel.authorizationCode
                    )
                )
            ).responseDecodable(of: LoginResultDTO.self) { response in
                print("--------------------------------------------------------------------------------")
                print("* REQUEST URL: \(String(describing: response.request))")
                
                // reponse data 출력하기
                if
                    let data = response.data,
                    let utf8Text = String(data: data, encoding: .utf8) {
                    print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                }
                print("--------------------------------------------------------------------------------")
                
                switch response.result {
                case .success(let data):
                    KeyChainManager.create(storeElement: .accessToken, content: data.accessToken)
                    KeyChainManager.create(storeElement: .refreshToken, content: data.refreshToken)
                    KeyChainManager.create(storeElement: .userID, content: String(data.userID))
                    
                    observer.onNext(data.isMember)
                case .failure(let error):
                    if let underlyingError = error.underlyingError as? NSError,
                       underlyingError.code == URLError.notConnectedToInternet.rawValue {
                        observer.onError(ErrorToastCase.internetError)
                    } else if let underlyingError = error.underlyingError as? NSError,
                              underlyingError.code == 13 {
                        observer.onError(ErrorToastCase.serverError)
                    } else {
                        observer.onError(ErrorToastCase.clientError)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func logout() -> Observable<Void> {
        return Observable<Void>.create { observer in
            if KeyChainManager.read(storeElement: .accessToken) != nil,
               KeyChainManager.read(storeElement: .refreshToken) != nil,
               KeyChainManager.read(storeElement: .userID) != nil {
                KeyChainManager.delete(storeElement: .accessToken)
                KeyChainManager.delete(storeElement: .refreshToken)
                KeyChainManager.delete(storeElement: .userID)
            }
            observer.onNext(())
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func resign() -> Observable<Void> {
        return Observable<Void>.create { observer in
            guard let userID = KeyChainManager.read(storeElement: .userID) else {
                observer.onError(ErrorToastCase.clientError)
                return Disposables.create()
            }
            self.session.request(
                RankInAPI.resign(
                    resignDTO: UserDTO(userID: userID)
                ),
                interceptor: AuthManager()
            )
            .response { response in
                
                        print("--------------------------------------------------------------------------------")
                        print("* REQUEST URL: \(String(describing: response.request))")
                        
                        // reponse data 출력하기
                        if
                            let data = response.data,
                            let utf8Text = String(data: data, encoding: .utf8) {
                            print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                        }
                        print("--------------------------------------------------------------------------------")
                        
                    switch response.result {
                    case .success:
                        KeyChainManager.delete(storeElement: .accessToken)
                        KeyChainManager.delete(storeElement: .refreshToken)
                        KeyChainManager.delete(storeElement: .userID)
                        observer.onNext(())
                        observer.onCompleted()
                    case .failure(let error):
                        if let underlyingError = error.underlyingError as? NSError,
                           underlyingError.code == URLError.notConnectedToInternet.rawValue {
                            observer.onError(ErrorToastCase.internetError)
                        } else if let underlyingError = error.underlyingError as? NSError,
                                  underlyingError.code == 13 {
                            observer.onError(ErrorToastCase.serverError)
                        } else {
                            observer.onError(ErrorToastCase.clientError)
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchMyInformation() -> Observable<UserInformation> {
        return Observable<UserInformation>.create { observer -> Disposable in
            guard let userID = KeyChainManager.read(storeElement: .userID) else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.session.request(
                RankInAPI.fetchUserInformation(userDTO: UserDTO(userID: userID)),
                interceptor: AuthManager()
            ).responseDecodable(of: UserInformationDTO.self) { response in
                print("--------------------------------------------------------------------------------")
                print("* REQUEST URL: \(String(describing: response.request))")
                
                // reponse data 출력하기
                if
                    let data = response.data,
                    let utf8Text = String(data: data, encoding: .utf8) {
                    print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                }
                print("--------------------------------------------------------------------------------")
                
                switch response.result {
                case .success(let data):
                    observer.onNext(data.toEntity())
                    observer.onCompleted()
                case .failure(let error):
                    dump(error)
                    if let underlyingError = error.underlyingError as? NSError,
                       underlyingError.code == URLError.notConnectedToInternet.rawValue {
                        observer.onError(ErrorToastCase.internetError)
                    } else if let underlyingError = error.underlyingError as? NSError,
                              underlyingError.code == 13 {
                        observer.onError(ErrorToastCase.serverError)
                    } else {
                        observer.onError(ErrorToastCase.clientError)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func fetchMyStat() -> Observable<UserStat> {
        Observable<UserStat>.create { observer -> Disposable in
            guard let userID = KeyChainManager.read(storeElement: .userID) else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.session.request(
                RankInAPI.fetchUserStat(
                    userDTO: UserDTO(userID: userID)),
                interceptor: AuthManager()
            )
            .responseDecodable(of: UserStatDTO.self) { response in
                print("--------------------------------------------------------------------------------")
                print("* REQUEST URL: \(String(describing: response.request))")
                
                // reponse data 출력하기
                if
                    let data = response.data,
                    let utf8Text = String(data: data, encoding: .utf8) {
                    print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                }
                print("--------------------------------------------------------------------------------")
                
                switch response.result {
                case .success(let dto):
                    observer.onNext(dto.toEntity())
                case .failure(let error):
                    dump(error)
                    if let underlyingError = error.underlyingError as? NSError,
                       underlyingError.code == URLError.notConnectedToInternet.rawValue {
                        observer.onError(ErrorToastCase.internetError)
                    } else if let underlyingError = error.underlyingError as? NSError,
                              underlyingError.code == 13 {
                        observer.onError(ErrorToastCase.serverError)
                    } else {
                        observer.onError(ErrorToastCase.clientError)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
}
