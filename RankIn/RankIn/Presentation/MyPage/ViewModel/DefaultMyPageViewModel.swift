//
//  DefaultMyPageViewModel.swift
//  RankIn
//
//  Created by 조성민 on 6/4/24.
//

import RxSwift
import RxRelay

final class DefaultMyPageViewModel: MyPageViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let toLogin = PublishRelay<Void>()
    
    let dependency: MyPageViewModelDependency
    
    init(dependency: MyPageViewModelDependency) {
        self.dependency = dependency
    }
    
    func transform(input: MyPageViewModelInput) -> MyPageViewModelOutput {
        input.logout
            .bind { _ in
                self.logout()
            }
            .disposed(by: disposeBag)
        
        input.resign
            .bind { _ in
                self.resign()
            }
            .disposed(by: disposeBag)
        
        return MyPageViewModelOutput(toLogin: toLogin)
    }
    
}

private extension DefaultMyPageViewModel {
    
    func logout() {
        dependency.logOutUseCase
            .execute()
            .subscribe { _ in
                self.toLogin.accept(())
            } onError: { error in
                dump(error)
            }
            .disposed(by: disposeBag)
    }
    
    func resign() {
        dependency.resignUseCase
            .execute()
            .subscribe { _ in
                self.toLogin.accept(())
            } onError: { error in
                dump(error)
            }
            .disposed(by: disposeBag)
    }
    
}
