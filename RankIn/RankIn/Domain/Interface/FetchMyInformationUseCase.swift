//
//  FetchMyInformationUseCase.swift
//  RankIn
//
//  Created by 조성민 on 6/8/24.
//

import RxSwift

protocol FetchMyInformationUseCase {
    
    var repository: UserRepository { get }
    
    func execute() -> Observable<UserInformation>
    
}
