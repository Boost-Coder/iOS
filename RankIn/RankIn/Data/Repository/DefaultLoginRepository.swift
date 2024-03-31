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
    
    func appleLogin(appleLoginModel: AppleLoginModel) -> Observable<JWT> {
        return Observable<JWT>.create { observer -> Disposable in
            self.session.request(
                RankInAPI.appleLogin(
                    appleLoginDTO: AppleLoginDTO(
                        identityToken: appleLoginModel.identityToken,
                        authorizationCode: appleLoginModel.authorizationCode
                    )
                )
            ).responseDecodable(of: JWTDTO.self) { response in
                switch response.result {
                case .success(let data):
                    // TODO: 로직 처리 (키 관리)
                    observer.onNext(JWT(accessToken: data.accessToken, refreshToken: data.refreshToken))
                case .failure(let error):
                    dump(error)
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
}
