//
//  LoginRepository.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import Alamofire
import RxSwift

protocol LoginRepository {
    
    var session: Session { get }
    
    func appleLogin(
        appleLoginModel: AppleLoginModel
    ) -> Observable<JWT>
    
}
