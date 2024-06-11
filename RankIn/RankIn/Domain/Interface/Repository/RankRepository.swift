//
//  RankRepository.swift
//  RankIn
//
//  Created by 조성민 on 5/22/24.
//

import RxSwift

protocol RankRepository {
    
    func fetchRankList() -> Observable<[RankTableViewCellContents]>
    
    func fetchMyRank() -> Observable<UserRank>
    
    func versus(row: Int) -> Observable<Versus>
    
}
