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
                
                print("* REQUEST URL: \(String(describing: response.request))")
                
                // reponse data 출력하기
                if
                    let data = response.data,
                    let utf8Text = String(data: data, encoding: .utf8) {
                    print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                }
                
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
    
}
