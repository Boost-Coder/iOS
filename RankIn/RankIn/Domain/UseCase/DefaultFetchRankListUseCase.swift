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
    
    func execute(fetchRankComponents: FetchRankComponents? = nil) -> Observable<[RankTableViewCellContents]> {
        // TODO: fetchRankList 이후 getRankCellContents로 이루어져서 return 할 수 있도록 수정
        return repository.fetchRankList(fetchRankComponents: fetchRankComponents)
    }
    
}
