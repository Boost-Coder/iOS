//
//  SetBaekjoonIDUseCase.swift
//  RankIn
//
//  Created by 조성민 on 5/12/24.
//

import RxSwift

protocol SetBaekjoonIDUseCase {
    
    var repository: SignUpRepository { get }
    
    func execute(id: String) -> Observable<Void>
    
}
