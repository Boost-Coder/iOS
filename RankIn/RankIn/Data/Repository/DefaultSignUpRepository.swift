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
                    observer.onNext(data.isSejong)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
}
