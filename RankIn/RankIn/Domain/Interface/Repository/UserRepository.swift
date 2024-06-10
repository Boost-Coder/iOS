//
//  UserRepository.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import Alamofire
import RxSwift

protocol UserRepository {
    
    var session: Session { get }
    
    func appleLogin(
        appleLoginModel: AppleLoginModel
    ) -> Observable<Bool>
    
    func logout() -> Observable<Void>
    
    func resign() -> Observable<Void>
    
    func fetchMyInformation() -> Observable<UserInformation>
    
    func fetchMyStat() -> Observable<UserStat>
    
}
