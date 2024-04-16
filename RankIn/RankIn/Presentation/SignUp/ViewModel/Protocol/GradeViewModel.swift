//
//  GradeViewModel.swift
//  RankIn
//
//  Created by 조성민 on 4/17/24.
//

import RxSwift
import RxRelay

protocol GradeViewModel {
    
    var dependency: GradeViewModelDependency { get }
    
    func transform(input: GradeViewModelInput) -> GradeViewModelOutput
    
}

struct GradeViewModelInput {
    
    let nextButtonTapped: PublishRelay<String>
    
}

struct GradeViewModelOutput {
    
    let gradeSuccess: PublishRelay<Void>
    let gradeFailure: PublishRelay<Void>
    
}

struct GradeViewModelDependency {
    
    let setGradeUseCase: SetGradeUseCase
    
}
