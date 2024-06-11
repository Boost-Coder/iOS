//
//  DefaultFetchMyRankUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/12/24.
//

import RxSwift

struct DefaultFetchMyRankUseCase: FetchMyRankUseCase {
    
    let repository: RankRepository
    
    func execute() -> Observable<UserRank> {
        return repository.fetchMyRank()
    }
    
}
