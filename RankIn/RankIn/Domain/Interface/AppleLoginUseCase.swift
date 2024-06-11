//
//  AppleLoginUseCase.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import RxSwift

protocol AppleLoginUseCase {
    
    var repository: UserRepository { get }
    
    func execute(
        requiredValue: AppleLoginModel
    ) -> Observable<Bool>
    
}
