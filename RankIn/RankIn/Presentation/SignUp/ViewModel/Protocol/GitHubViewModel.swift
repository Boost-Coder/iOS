//
//  GitHubViewModel.swift
//  RankIn
//
//  Created by 조성민 on 4/18/24.
//

import RxSwift
import RxRelay

protocol GitHubViewModel {
    
    var dependency: GitHubViewModelDependency { get }
    
    func transform(input: GitHubViewModelInput) -> GitHubViewModelOutput
    
}

struct GitHubViewModelInput {
    
    let gitHubAuthorizationSuccess: PublishRelay<String>
    
}

struct GitHubViewModelOutput {
    
    let gitHubAuthorizationRegisterSuccess: PublishRelay<Void>
    let gitHubAuthorizationRegisterFailure: PublishRelay<Void>
    let errorPublisher: PublishRelay<ErrorToastCase>
    
}

struct GitHubViewModelDependency {
    
    let gitHubAuthorizationUseCase: GitHubAuthorizationUseCase
    let gitHubAuthorizationRegisterUseCase: GitHubAuthorizationRegisterUseCase
    
}
