//
//  DefaultSetGradeUseCase.swift
//  RankIn
//
//  Created by 조성민 on 4/17/24.
//

import RxSwift

struct DefaultSetGradeUseCase: SetGradeUseCase {
    
    let repository: SignUpRepository
    
    func execute(grade: Double) -> Observable<Void> {
        return repository.setGrade(grade: grade)
    }
    
}
