//
//  DefaultNicknameViewModel.swift
//  RankIn
//
//  Created by 조성민 on 4/14/24.
//

import RxSwift

final class DefaultNicknameViewModel: NicknameViewModel {
    
    private let disposeBag = DisposeBag()
    let dependency: NicknameViewModelDependency
    	
    func transform(input: NicknameViewModelInput) -> NicknameViewModelOutput {
        input.nextButtonTapped
            .bind { nickname in
            }
            .disposed(by: disposeBag)
        
        return NicknameViewModelOutput()
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
                onNext: { isSuccessed in
                    // TODO: 성공 여부 처리
                    if isSuccessed {
                        print("닉네임 설정 성공")
                    } else {
                        print("닉네임 설정 실패")
                    }
                },
                onError: { error in
                    // TODO: error 처리
                    dump(error)
                })
            .disposed(by: disposeBag)
    }
    
}
