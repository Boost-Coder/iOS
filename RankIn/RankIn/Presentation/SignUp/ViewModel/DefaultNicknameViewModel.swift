//
//  DefaultNicknameViewModel.swift
//  RankIn
//
//  Created by 조성민 on 4/14/24.
//

import RxSwift
import RxRelay

final class DefaultNicknameViewModel: NicknameViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let nicknameSuccess = PublishRelay<Void>()
    private let nicknameFailure = PublishRelay<Void>()
    private let errorPublisher = PublishRelay<ErrorToastCase>()
    
    let dependency: NicknameViewModelDependency
    	
    func transform(input: NicknameViewModelInput) -> NicknameViewModelOutput {
        input.nextButtonTapped
            .bind { nickname in
                self.setNickname(nickname: nickname)
            }
            .disposed(by: disposeBag)
        
        return NicknameViewModelOutput(
            nicknameSuccess: nicknameSuccess,
            nicknameFailure: nicknameFailure,
            errorPublisher: errorPublisher
        )
    }
    
    init(dependency: NicknameViewModelDependency) {
        self.dependency = dependency
    }
    
}

private extension DefaultNicknameViewModel {
    
    func setNickname(nickname: String) {
        dependency.setNicknameUseCase
            .execute(nickname: nickname)
            .subscribe(
                onNext: { [weak self] isSuccess in
                    if isSuccess {
                        self?.nicknameSuccess.accept(())
                    } else {
                        self?.nicknameFailure.accept(())
                    }
                },
                onError: { error in
                    guard let error = error as? ErrorToastCase else {
                        dump(error)
                        self.errorPublisher.accept(.clientError)
                        return
                    }
                    self.errorPublisher.accept(error)
                })
            .disposed(by: disposeBag)
    }
    
}
