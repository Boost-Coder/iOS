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
        
    }
    
    struct LoginViewModelOutput {
        
    }
    
    func transform(input: Input) -> Output {
        let output = LoginViewModelOutput()
        
        return output
    }
    
}
