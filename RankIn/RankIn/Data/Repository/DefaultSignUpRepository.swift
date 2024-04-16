//
//  DefaultSignUpRepository.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import Alamofire
import RxSwift

final class DefaultSignUpRepository: SignUpRepository {
    
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func sejongLogin(loginInfo: SejongLoginInfo) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            self.session.request(RankInAPI.sejongLogin(SejongLoginInfoDTO: SejongLoginInfoDTO(
                id: loginInfo.id, pw: loginInfo.pw
            )), interceptor: AuthManager())
            .responseDecodable(of: SejongLoginResultDTO.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data.isAuthorized)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func setNickname(nickname: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let userID = KeyChainManager.read(storeElement: .userID) {
                self.session.request(
                    RankInAPI.setNickname(
                        userID: userID, nickname: nickname
                    ),
                    interceptor: AuthManager()
                )
                .responseData(completionHandler: { response in
                    switch response.result {
                    case .success:
                        observer.onNext(true)
                    case .failure(let error):
                        if error.responseCode == 409 {
                            observer.onNext(false)
                        } else {
                            observer.onError(error)
                        }
                    }
                })
            } else {  
                observer.onError(RepositoryError.noUserID)
            }
            
            return Disposables.create()
            
        }
    }
    
}
