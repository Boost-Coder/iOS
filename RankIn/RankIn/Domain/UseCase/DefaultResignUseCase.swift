//
//  DefaultResignUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/4/24.
//

import RxSwift

struct DefaultResignUseCase: ResignUseCase {
    
    let repository: UserRepository
    
    func execute() -> Observable<Void> {
        return repository.resign()
    }
    
}
