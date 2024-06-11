//
//  LogOutUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/4/24.
//

import RxSwift

protocol LogOutUseCase {
    
    var repository: UserRepository { get }
    
    func execute() -> Observable<Void>
    
}
