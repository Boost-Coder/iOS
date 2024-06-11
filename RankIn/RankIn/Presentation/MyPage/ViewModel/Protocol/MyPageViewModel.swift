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
    
    let viewDidLoad: PublishRelay<Void>
    let logout: PublishRelay<Void>
    let resign: PublishRelay<Void>
    
}

struct MyPageViewModelOutput {
    
    let toLogin: PublishRelay<Void>
    let myInformation: PublishRelay<UserInformation>
    let myStat: PublishRelay<UserStat>
    
}

struct MyPageViewModelDependency {
    
    let fetchMyInfromationUseCase: FetchMyInformationUseCase
    let fetchMyStatUseCase: FetchMyStatUseCase
    let logOutUseCase: LogOutUseCase
    let resignUseCase: ResignUseCase
    
}
