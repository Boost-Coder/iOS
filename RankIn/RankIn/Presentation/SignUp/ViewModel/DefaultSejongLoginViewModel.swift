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
            loginSuccessed: loginSuccessed
        )
    }
    
}

private extension DefaultSejongLoginViewModel {
    
    func sejongLogin(loginInfo: SejongLoginInfo) {
        dependency
            .sejongLoginUseCase
            .execute(loginInfo: loginInfo)
            .subscribe { isAuthorized in
                // TODO: 로그인 성공 및 실패 처리
                if isAuthorized {
                    self.loginSuccessed.accept(())
                } else {
                    self.loginFailed.accept(())
                }
            } onError: { error in
                dump(error)
                // TODO: error 처리
            }
            .disposed(by: disposeBag)
    }
    
}
