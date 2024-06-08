//
//  MyPageViewModel.swift
//  RankIn
//
//  Created by 조성민 on 6/4/24.
//

import RxSwift
import RxRelay

protocol MyPageViewModel {
    
    var dependency: MyPageViewModelDependency { get }
    
    func transform(input: MyPageViewModelInput) -> MyPageViewModelOutput
    
}

struct MyPageViewModelInput {
    
    let logout: PublishRelay<Void>
    let resign: PublishRelay<Void>
    
}

struct MyPageViewModelOutput {
    
    let toLogin: PublishRelay<Void>
    
}

struct MyPageViewModelDependency {
    
    let logOutUseCase: LogOutUseCase
    let resignUseCase: ResignUseCase
    
}
