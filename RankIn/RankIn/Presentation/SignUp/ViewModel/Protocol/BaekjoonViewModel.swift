//
//  BaekjoonViewModel.swift
//  RankIn
//
//  Created by 조성민 on 5/12/24.
//

import RxSwift
import RxRelay

protocol BaekjoonViewModel {
    
    var dependency: BaekjoonViewModelDependency { get }
    
    func transform(input: BaekjoonViewModelInput) -> BaekjoonViewModelOutput
    
}

struct BaekjoonViewModelInput {
    
    let nextButtonTapped: PublishRelay<String>
    
}

struct BaekjoonViewModelOutput {
    
    let baekjoonSuccess: PublishRelay<Void>
    let baekjoonFailure: PublishRelay<Void>
    let errorPublisher: PublishRelay<ErrorToastCase>
    
}

struct BaekjoonViewModelDependency {
    
    let setBaekjoonIDUseCase: SetBaekjoonIDUseCase
    
}
