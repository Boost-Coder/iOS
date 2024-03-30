//
//  DefaultLoginViewModel.swift
//  RankIn
//
//  Created by 조성민 on 3/28/24.
//

import RxRelay
import RxSwift

final class DefaultLoginViewModel: LoginViewModel {
    
    private let disposeBag = DisposeBag()
    
    let dependency: LoginViewModelDependency
    
    init(dependency: LoginViewModelDependency) {
        self.dependency = dependency
    }
    
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
        
        input
            .appleLoginSuccess
            .bind { appleLoginModel in
                
            }
            .disposed(by: disposeBag)
        
        let output = LoginViewModelOutput()
        
        return output
    }
    
}
