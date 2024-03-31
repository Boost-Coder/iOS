//
//  DefaultAppleLoginUseCase.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import RxSwift

struct DefaultAppleLoginUseCase: AppleLoginUseCase {
    
    let repository: LoginRepository
    
    func execute(
        requiredValue: AppleLoginModel
    ) -> Observable<JWT> {
        // TODO: 로직 처리 (키 관리)
        return repository.appleLogin(appleLoginModel: requiredValue)
    }
}
