//
//  DefaultSejongLoginViewModel.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import RxSwift
import RxRelay

final class DefaultSejongLoginViewModel: SejongLoginViewModel {
    
    private let disposeBag = DisposeBag()
    
    let dependency: SejongLoginViewModelDependency
    
    private let loginFailed = PublishRelay<Void>()
    private let loginSuccessed = PublishRelay<Void>()
    private let errorPublisher = PublishRelay<ErrorToastCase>()
    
    init(dependency: SejongLoginViewModelDependency) {
        self.dependency = dependency
    }
    
    func transform(input: SejongLoginViewModelInput) -> SejongLoginViewModelOutput {
        
        input.loginButtonTapped
            .bind { [weak self] loginInfo in
                self?.sejongLogin(loginInfo: loginInfo)
            }
            .disposed(by: disposeBag)
        
        return SejongLoginViewModelOutput(
            loginFailed: loginFailed,
            loginSuccessed: loginSuccessed,
            errorPublisher: errorPublisher
        )
    }
    
}

private extension DefaultSejongLoginViewModel {
    
    func sejongLogin(loginInfo: SejongLoginInfo) {
        dependency
            .sejongLoginUseCase
            .execute(loginInfo: loginInfo)
            .subscribe { isAuthorized in
                if isAuthorized {
                    self.loginSuccessed.accept(())
                } else {
                    self.loginFailed.accept(())
                }
            } onError: { error in
                guard let error = error as? ErrorToastCase else {
                    dump(error)
                    self.errorPublisher.accept(.clientError)
                    return
                }
                self.errorPublisher.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
}
