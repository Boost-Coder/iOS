//
//  RankRepository.swift
//  RankIn
//
//  Created by 조성민 on 5/22/24.
//

import RxSwift

protocol RankRepository {
    
    func fetchRankList(fetchRankComponents: FetchRankComponents?) -> Observable<[RankTableViewCellContents]>
    
}
