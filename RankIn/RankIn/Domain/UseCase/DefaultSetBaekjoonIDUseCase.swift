//
//  DefaultSetBaekjoonIDUseCase.swift
//  RankIn
//
//  Created by 조성민 on 5/12/24.
//

import RxSwift

struct DefaultSetBaekjoonIDUseCase: SetBaekjoonIDUseCase {
    
    let repository: SignUpRepository
    
    func execute(id: String) -> Observable<Void> {
        return repository.setBaekjoonID(id: id)
    }
    
}
