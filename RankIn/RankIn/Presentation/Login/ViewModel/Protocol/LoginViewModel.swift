//
//  LoginViewModel.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import RxSwift
import RxRelay

protocol LoginViewModel {
    
    var dependency: LoginViewModelDependency { get }
    
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput
    
}

struct LoginViewModelInput {
    
    let appleLoginSuccess: Observable<AppleLoginModel>
    
}

struct LoginViewModelOutput {
    
    let loginSuccessOutput: PublishRelay<Void>
    
}

struct LoginViewModelDependency {
    
    let appleLoginUseCase: AppleLoginUseCase
    
}
