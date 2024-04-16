//
//  DefaultLoginRepository.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import Alamofire
import RxSwift

final class DefaultLoginRepository: LoginRepository {
    
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
                switch response.result {
                case .success(let data):
                    KeyChainManager.create(storeElement: .accessToken, content: data.accessToken)
                    KeyChainManager.create(storeElement: .refreshToken, content: data.refreshToken)
                    KeyChainManager.create(storeElement: .userID, content: String(data.userID))
                    
                    observer.onNext(data.isMember)
                case .failure(let error):
                    dump(error)
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
}
