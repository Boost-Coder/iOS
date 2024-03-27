//
//  LoginViewModel.swift
//  RankIn
//
//  Created by 조성민 on 3/28/24.
//

import RxRelay
import RxSwift

final class LoginViewModel: ViewModel {
    
    private let disposeBag = DisposeBag()
    
    typealias Input = LoginViewModelInput
    typealias Output = LoginViewModelOutput
    
    struct LoginViewModelInput {
        let appleLoginButtonTapped: Observable<Void>
    }
    
    struct LoginViewModelOutput {
        let appleLoginOutput: PublishRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        let output = LoginViewModelOutput(appleLoginOutput: PublishRelay<Void>())
        input
            .appleLoginButtonTapped
            .asObservable()
            .map { $0 } // TODO: Logic
            .bind(to: output.appleLoginOutput)
            .disposed(by: disposeBag)
        
        return output
    }
    
}
