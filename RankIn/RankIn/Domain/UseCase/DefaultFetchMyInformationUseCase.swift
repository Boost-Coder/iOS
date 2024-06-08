//
//  DefaultFetchMyInformationUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/8/24.
//

import RxSwift

struct DefaultFetchMyInformationUseCase: FetchMyInformationUseCase {
    
    let repository: UserRepository
    
    func execute() -> Observable<UserInformation> {
        return repository.fetchMyInformation()
    }
    
}
