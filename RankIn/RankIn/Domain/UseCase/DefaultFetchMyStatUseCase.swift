//
//  DefaultFetchMyStatUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/11/24.
//

import RxSwift

struct DefaultFetchMyStatUseCase: FetchMyStatUseCase {
    
    let repository: UserRepository
    
    func execute() -> Observable<UserStat> {
        return repository.fetchMyStat()
    }
    
}
