//
//  DefaultBaekjoonViewModel.swift
//  RankIn
//
//  Created by 조성민 on 5/12/24.
//

import RxSwift
import RxRelay

final class DefaultBaekjoonViewModel: BaekjoonViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let baekjoonSuccess = PublishRelay<Void>()
    private let baekjoonFailure = PublishRelay<Void>()
    private let errorPublisher = PublishRelay<ErrorToastCase>()
    
    let dependency: BaekjoonViewModelDependency
    
    func transform(input: BaekjoonViewModelInput) -> BaekjoonViewModelOutput {
        input.nextButtonTapped
            .bind { baekjoonID in
                self.setBaekjoonID(id: baekjoonID)
            }
            .disposed(by: disposeBag)
        
        return BaekjoonViewModelOutput(
            baekjoonSuccess: baekjoonSuccess,
            baekjoonFailure: baekjoonFailure,
            errorPublisher: errorPublisher
        )
    }
    
    init(dependency: BaekjoonViewModelDependency) {
        self.dependency = dependency
    }
    
}

private extension DefaultBaekjoonViewModel {
    
    func setBaekjoonID(id: String) {
        if id.isEmpty {
            baekjoonFailure.accept(())
        }
        dependency.setBaekjoonIDUseCase
            .execute(id: id)
            .subscribe { [weak self] _ in
                self?.baekjoonSuccess.accept(())
            } onError: { error in
                guard let error = error as? ErrorToastCase else {
                    dump(error)
                    self.errorPublisher.accept(.clientError)
                    return
                }
                self.errorPublisher.accept(error)
            }
            .disposed(by: disposeBag)
    }
    
}
