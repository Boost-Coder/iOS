//
//  FetchMyRankUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/12/24.
//

import RxSwift

protocol FetchMyRankUseCase {
    
    var repository: RankRepository { get }
    
    func execute() -> Observable<UserRank>
    
}
