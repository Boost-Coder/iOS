//
//  HomeViewModel.swift
//  RankIn
//
//  Created by 조성민 on 5/22/24.
//

import RxSwift
import RxRelay

protocol HomeViewModel {
    
    var dependency: HomeViewModelDependency { get }
    
    func transform(input: HomeViewModelInput) -> HomeViewModelOutput
    
}

struct HomeViewModelInput {
    
    let getRankTableCellContent: PublishRelay<Void>
    let getMyInformation: PublishRelay<Void>
    
}

struct HomeViewModelOutput {
    
    let fetchRankListComplete: PublishRelay<[RankTableViewCellContents]>
    let errorPublisher: PublishRelay<ErrorToastCase>
    let getMyRank: PublishRelay<UserRank>
    
}

struct HomeViewModelDependency {
    
    let fetchRankListUseCase: FetchRankListUseCase
    let fetchMyRankUseCase: FetchMyRankUseCase
    
}
