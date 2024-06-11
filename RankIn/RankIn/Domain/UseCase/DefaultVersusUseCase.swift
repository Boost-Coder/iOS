//
//  DefaultVersusUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/12/24.
//

import RxSwift

struct DefaultVersusUseCase: VersueUseCase {
    
    let repository: RankRepository
    
    func execute(row: Int) -> Observable<Versus> {
        return repository.versus(row: row)
    }
    
}
