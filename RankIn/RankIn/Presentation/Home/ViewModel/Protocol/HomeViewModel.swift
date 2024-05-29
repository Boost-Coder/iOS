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
    
    let viewDidLoad: PublishRelay<Void>
    let getRankTableCellContent: PublishRelay<FetchRankComponents>
    
}

struct HomeViewModelOutput {
    
    let fetchRankListComplete: PublishRelay<[RankTableViewCellContents]>
    let errorPublisher: PublishRelay<ErrorToastCase>
    
}

struct HomeViewModelDependency {
    
    let fetchRankListUseCase: FetchRankListUseCase
    
}
