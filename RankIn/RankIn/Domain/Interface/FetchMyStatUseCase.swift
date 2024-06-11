//
//  FetchMyStatUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/11/24.
//

import RxSwift

protocol FetchMyStatUseCase {
    
    var repository: UserRepository { get }
    
    func execute() -> Observable<UserStat>
    
}
