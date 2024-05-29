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
        input.viewDidLoad
            .bind { _ in
                self.viewDidLoad()
            }
            .disposed(by: disposeBag)
        input.getRankTableCellContent
            .bind { components in
                self.loadRankCellContents(fetchRankComponents: components)
            }
            .disposed(by: disposeBag)
        
        return HomeViewModelOutput(
            fetchRankListComplete: fetchRankListComplete,
            errorPublisher: errorPublisher
        )
    }
    
}

private extension DefaultHomeViewModel {
    
    func viewDidLoad() {
        dependency.fetchRankListUseCase
            .execute(fetchRankComponents: nil)
            .subscribe { [weak self] contentsList in
                self?.fetchRankListComplete.accept(contentsList)
            } onError: { [weak self] error in
                self?.errorPublisher.accept(.clientError)
            }
            .disposed(by: disposeBag)
    }
    
    func loadRankCellContents(fetchRankComponents: FetchRankComponents) {
        dependency.fetchRankListUseCase
            .execute(fetchRankComponents: fetchRankComponents)
            .subscribe { [weak self] contents in
                
            } onError: { [weak self] error in
                
            }
            .disposed(by: disposeBag)
    }
    
}
