//
//  SejongLoginViewModel.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import RxSwift
import RxRelay

protocol SejongLoginViewModel {
    
    var dependency: SejongLoginViewModelDependency { get }
    
    func transform(input: SejongLoginViewModelInput) -> SejongLoginViewModelOutput
    
}

struct SejongLoginViewModelInput {
    
    let loginButtonTapped: PublishRelay<SejongLoginInfo>
    
}

struct SejongLoginViewModelOutput {
    
}

struct SejongLoginViewModelDependency {
    
    let sejongLoginUseCase: SejongLoginUseCase
    
}
