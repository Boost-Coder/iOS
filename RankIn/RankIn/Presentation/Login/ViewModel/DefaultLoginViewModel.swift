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
    
    // MARK: Output
    let loginSuccessOutput = PublishRelay<Void>()
    
    init(dependency: LoginViewModelDependency) {
        self.dependency = dependency
    }
    
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
        
        input
            .appleLoginSuccess
            .bind(onNext: { appleLoginModel in
                self.appleLogin(appleLoginModel: appleLoginModel)
            })
            .disposed(by: disposeBag)
        
        let output = LoginViewModelOutput(loginSuccessOutput: loginSuccessOutput)
        
        return output
    }
    
}

private extension DefaultLoginViewModel {
    
    func appleLogin(appleLoginModel: AppleLoginModel) {
        dependency
            .appleLoginUseCase
            .execute(
                requiredValue: appleLoginModel
            )
            .subscribe { [weak self] jwt in
                self?.loginSuccessOutput.accept(())
            } onError: { [weak self] error in
                dump(error)
                // TODO: 실패 핸들링
            }
            .disposed(by: disposeBag)
    }
    
}
