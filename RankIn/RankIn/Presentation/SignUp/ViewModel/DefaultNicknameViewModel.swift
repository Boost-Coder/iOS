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
    
    let dependency: NicknameViewModelDependency
    	
    func transform(input: NicknameViewModelInput) -> NicknameViewModelOutput {
        input.nextButtonTapped
            .bind { nickname in
                self.setNickname(nickname: nickname)
            }
            .disposed(by: disposeBag)
        
        return NicknameViewModelOutput(
            nicknameSuccess: nicknameSuccess,
            nicknameFailure: nicknameFailure
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
                    // TODO: 에러 처리
                    dump(error)
                })
            .disposed(by: disposeBag)
    }
    
}
