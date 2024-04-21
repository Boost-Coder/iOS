//
//  GitHubAuthorizationRegisterUseCase.swift
//  RankIn
//
//  Created by 조성민 on 4/21/24.
//

import RxSwift

protocol GitHubAuthorizationRegisterUseCase {
    
    var repository: SignUpRepository { get }
    
    func execute(code: String) -> Observable<Bool>
    
}
