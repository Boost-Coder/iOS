//
//  SetGradeUseCase.swift
//  RankIn
//
//  Created by 조성민 on 4/17/24.
//

import RxSwift

protocol SetGradeUseCase {
    
    var repository: SignUpRepository { get }
    
    func execute(grade: String) -> Observable<Void>
    
}
