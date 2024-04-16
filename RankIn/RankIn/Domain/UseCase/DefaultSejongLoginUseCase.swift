//
//  DefaultSejongLoginUseCase.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import RxSwift

struct DefaultSejongLoginUseCase: SejongLoginUseCase {
    
    let repository: SignUpRepository
    
    func execute(loginInfo: SejongLoginInfo) -> Observable<Bool> {
        return repository.sejongLogin(loginInfo: loginInfo)
    }
    
}
