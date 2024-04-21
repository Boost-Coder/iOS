//
//  DefaultGitHubAuthorizationUseCase.swift
//  RankIn
//
//  Created by 조성민 on 4/18/24.
//

import RxSwift

struct DefaultGitHubAuthorizationUseCase: GitHubAuthorizationUseCase {
    
    let repository: SignUpRepository
    
    func execute(code: String) -> Observable<String> {
        return repository.gitHubAuthorization(code: code)
    }
    
}
