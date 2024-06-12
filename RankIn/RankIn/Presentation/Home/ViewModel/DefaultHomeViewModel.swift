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
    let getMyRank = PublishRelay<UserRank>()
    let versusRank = PublishRelay<CompareContents>()
    
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
        
        input.getMyInformation
            .debounce(.milliseconds(50), scheduler: MainScheduler())
            .bind { _ in
                self.fetchMyInformation()
            }
            .disposed(by: disposeBag)
        
        input.cellSelected
            .debounce(.milliseconds(50), scheduler: MainScheduler())
            .bind { row in
                self.versus(row: row)
            }
            .disposed(by: disposeBag)

        return HomeViewModelOutput(
            fetchRankListComplete: fetchRankListComplete,
            errorPublisher: errorPublisher,
            getMyRank: getMyRank, 
            versusRank: versusRank
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
    
    func fetchMyInformation() {
        dependency.fetchMyRankUseCase
            .execute()
            .debounce(.milliseconds(5), scheduler: MainScheduler())
            .subscribe { [weak self] rank in
                self?.getMyRank.accept(rank)
            } onError: { [weak self] error in
                self?.errorPublisher.accept(.clientError)
            }
            .disposed(by: disposeBag)
    }
    
    func versus(row: Int) {
        dependency.versusUseCase
            .execute(row: row)
            .debounce(.milliseconds(5), scheduler: MainScheduler())
            .subscribe { [weak self] versus in
                self?.versusRank.accept(versus)
            } onError: { [weak self] error in
                self?.errorPublisher.accept(.clientError)
            }
            .disposed(by: disposeBag)
    }
    
}
