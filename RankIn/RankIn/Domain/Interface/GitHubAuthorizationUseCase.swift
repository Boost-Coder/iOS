//
//  GitHubAuthorizationUseCase.swift
//  RankIn
//
//  Created by 조성민 on 4/18/24.
//

import RxSwift

protocol GitHubAuthorizationUseCase {
    
    var repository: SignUpRepository { get }
    
    func execute(code: String) -> Observable<String>
    
}
