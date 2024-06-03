//
//  DefaultHomeViewModel.swift
//  RankIn
//
//  Created by 조성민 on 5/22/24.
//

import RxRelay
import RxSwift

final class DefaultHomeViewModel: HomeViewModel {
    
    private let disposeBag = DisposeBag()
    
    let dependency: HomeViewModelDependency
    
    // MARK: Output
    let errorPublisher = PublishRelay<ErrorToastCase>()
    let fetchRankListComplete = PublishRelay<[RankTableViewCellContents]>()
    
    init(dependency: HomeViewModelDependency) {
        self.dependency = dependency
    }
    
    func transform(input: HomeViewModelInput) -> HomeViewModelOutput {
        input.getRankTableCellContent
            .debounce(.milliseconds(50), scheduler: MainScheduler())
            .bind { _ in
                self.loadRankCellContents()
            }
            .disposed(by: disposeBag)

        return HomeViewModelOutput(
            fetchRankListComplete: fetchRankListComplete,
            errorPublisher: errorPublisher
        )
    }
    
}

private extension DefaultHomeViewModel {
    
    func loadRankCellContents() {
        dependency.fetchRankListUseCase
            .execute()
            .debounce(.milliseconds(5), scheduler: MainScheduler())
            .subscribe { [weak self] contentsList in
                self?.fetchRankListComplete.accept(contentsList)
            } onError: { [weak self] error in
                self?.errorPublisher.accept(.clientError)
            }
            .disposed(by: disposeBag)
    }
    
}
