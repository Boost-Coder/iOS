//
//  DefaultGradeViewModel.swift
//  RankIn
//
//  Created by 조성민 on 4/17/24.
//

import RxSwift
import RxRelay

final class DefaultGradeViewModel: GradeViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let gradeSuccess = PublishRelay<Void>()
    private let gradeFailure = PublishRelay<Void>()
    private let errorPublisher = PublishRelay<ErrorToastCase>()
    
    let dependency: GradeViewModelDependency
    
    func transform(input: GradeViewModelInput) -> GradeViewModelOutput {
        input.nextButtonTapped
            .bind { grade in
                self.setGrade(grade: grade)
            }
            .disposed(by: disposeBag)
        
        return GradeViewModelOutput(
            gradeSuccess: gradeSuccess,
            gradeFailure: gradeFailure,
            errorPublisher: errorPublisher
        )
    }
    
    init(dependency: GradeViewModelDependency) {
        self.dependency = dependency
    }
    
}

private extension DefaultGradeViewModel {
    
    func setGrade(grade: String) {
        // TODO: grade 유효성 검사
        if false {
            gradeFailure.accept(())
        }
        dependency.setGradeUseCase
            .execute(grade: grade)
            .subscribe { [weak self] _ in
                self?.gradeSuccess.accept(())
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
