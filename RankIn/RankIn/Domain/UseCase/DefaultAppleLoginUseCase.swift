//
//  DefaultAppleLoginUseCase.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import RxSwift

struct DefaultAppleLoginUseCase: AppleLoginUseCase {
    
    let repository: UserRepository
    
    func execute(
        requiredValue: AppleLoginModel
    ) -> Observable<Bool> {
        return repository.appleLogin(appleLoginModel: requiredValue)
    }
}
