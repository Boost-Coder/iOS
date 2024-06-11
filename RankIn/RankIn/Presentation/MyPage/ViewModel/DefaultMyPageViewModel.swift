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
    private let myInformation = PublishRelay<UserInformation>()
    private let myStat = PublishRelay<UserStat>()
    
    let dependency: MyPageViewModelDependency
    
    init(dependency: MyPageViewModelDependency) {
        self.dependency = dependency
    }
    
    func transform(input: MyPageViewModelInput) -> MyPageViewModelOutput {
        input.viewDidLoad
            .bind { _ in
                self.fetchMyInformation()
                self.fetchMyStat()
            }
            .disposed(by: disposeBag)
        
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
        
        return MyPageViewModelOutput(
            toLogin: toLogin,
            myInformation: myInformation,
            myStat: myStat
        )
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
    
    func fetchMyInformation() {
        dependency.fetchMyInfromationUseCase
            .execute()
            .subscribe { information in
                self.myInformation.accept(information)
            } onError: { error in
                dump(error)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchMyStat() {
        dependency.fetchMyStatUseCase
            .execute()
            .subscribe { stat in
                self.myStat.accept(stat)
            } onError: { error in
                dump(error)
            }
            .disposed(by: disposeBag)
    }
    
}
