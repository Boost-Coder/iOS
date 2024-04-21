//
//  DefaultGitHubAuthorizationRegisterUseCase.swift
//  RankIn
//
//  Created by 조성민 on 4/21/24.
//

import RxSwift

struct DefaultGitHubAuthorizationRegisterUseCase: GitHubAuthorizationRegisterUseCase {
    
    let repository: SignUpRepository
    
    func execute(code: String) -> Observable<Bool> {
        return repository.registerGitHubAuthorization(code: code)
    }
    
}
