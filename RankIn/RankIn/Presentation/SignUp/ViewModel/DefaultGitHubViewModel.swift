//
//  DefaultGitHubViewModel.swift
//  RankIn
//
//  Created by 조성민 on 4/18/24.
//

import RxSwift
import RxRelay

final class DefaultGitHubViewModel: GitHubViewModel {
    
    private let disposeBag = DisposeBag()
    let dependency: GitHubViewModelDependency
    
    // MARK: Output
    private let gitHubAuthorizationRegisterSuccess = PublishRelay<Void>()
    private let gitHubAuthorizationRegisterFailure = PublishRelay<Void>()
    private let errorPublisher = PublishRelay<ErrorToastCase>()
    
    init(dependency: GitHubViewModelDependency) {
        self.dependency = dependency
    }
    
    func transform(input: GitHubViewModelInput) -> GitHubViewModelOutput {
        input.gitHubAuthorizationSuccess
            .bind { code in
                self.gitHubAuthorization(code: code)
            }
            .disposed(by: disposeBag)
        
        return GitHubViewModelOutput(
            gitHubAuthorizationRegisterSuccess: gitHubAuthorizationRegisterSuccess,
            gitHubAuthorizationRegisterFailure: gitHubAuthorizationRegisterFailure,
            errorPublisher: errorPublisher
        )
    }
    
}

private extension DefaultGitHubViewModel {
    
    func gitHubAuthorization(code: String) {
        dependency
            .gitHubAuthorizationUseCase
            .execute(code: code)
            .subscribe { accessToken in
                self.accessTokenRegister(accessToken: accessToken)
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
    
    func accessTokenRegister(accessToken: String) {
        dependency
            .gitHubAuthorizationRegisterUseCase
            .execute(code: accessToken)
            .subscribe { isSuccess in
                if isSuccess {
                    self.gitHubAuthorizationRegisterSuccess.accept(())
                } else {
                    self.gitHubAuthorizationRegisterFailure.accept(())
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
