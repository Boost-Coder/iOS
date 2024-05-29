//
//  FetchRankListUseCase.swift
//  RankIn
//
//  Created by 조성민 on 5/22/24.
//

import RxSwift

protocol FetchRankListUseCase {
    
    var repository: RankRepository { get }
    
    func execute(fetchRankComponents: FetchRankComponents?) -> Observable<[RankTableViewCellContents]>
    
}
