//
//  VersueUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/12/24.
//

import RxSwift

protocol VersueUseCase {
    
    var repository: RankRepository { get }
    
    func execute(row: Int) -> Observable<CompareContents>
    
}
