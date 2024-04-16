//
//  SignUpRepository.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import RxSwift

protocol SignUpRepository {
    
    func sejongLogin(loginInfo: SejongLoginInfo) -> Observable<Bool>
    func setNickname(nickname: String) -> Observable<Bool>
    func setGrade(grade: String) -> Observable<Void>
    
}
