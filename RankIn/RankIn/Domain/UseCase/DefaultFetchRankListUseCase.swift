//
//  DefaultFetchRankListUseCase.swift
//  RankIn
//
//  Created by 조성민 on 5/22/24.
//

import RxSwift

struct DefaultFetchRankListUseCase: FetchRankListUseCase {
    
    private let disposeBag = DisposeBag()
    let repository: RankRepository
    
    func execute() -> Observable<[RankTableViewCellContents]> {
        return repository.fetchRankList()
    }
    
}
