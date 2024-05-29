//
//  LoadRankCellContentUseCase.swift
//  RankIn
//
//  Created by 조성민 on 5/23/24.
//

import RxSwift

protocol LoadRankCellContentUseCase {
    
    var repository: RankRepository { get }
    
    func execute(page: Int) -> Observable<[RankTableViewCellContents]>
    
}
