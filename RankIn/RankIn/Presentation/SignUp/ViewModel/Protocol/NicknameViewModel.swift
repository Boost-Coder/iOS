//
//  NicknameViewModel.swift
//  RankIn
//
//  Created by 조성민 on 4/14/24.
//

import RxSwift
import RxRelay

protocol NicknameViewModel {
    
    var dependency: NicknameViewModelDependency { get }
    
    func transform(input: NicknameViewModelInput) -> NicknameViewModelOutput
    
}

struct NicknameViewModelInput {
    
    let nextButtonTapped: PublishRelay<String>
    
}

struct NicknameViewModelOutput {
    
    let nicknameSuccess: PublishRelay<Void>
    let nicknameFailure: PublishRelay<Void>
    let errorPublisher: PublishRelay<ErrorToastCase>
    
}

struct NicknameViewModelDependency {
    
    let setNicknameUseCase: SetNicknameUseCase
    
}
