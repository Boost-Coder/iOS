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
    let loginSuccessOutput = PublishRelay<Bool>()
    let errorPublisher = PublishRelay<ErrorToastCase>()
    
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
        
        let output = LoginViewModelOutput(
            loginSuccessOutput: loginSuccessOutput,
            errorPublisher: errorPublisher
        )
        
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
            .subscribe { [weak self] isMember in
                self?.loginSuccessOutput.accept(isMember)
            } onError: { [weak self] error in
                guard let error = error as? ErrorToastCase else {
                    dump(error)
                    self?.errorPublisher.accept(.clientError)
                    return
                }
                self?.errorPublisher.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
}
