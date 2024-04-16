//
//  SetNicknameUseCase.swift
//  RankIn
//
//  Created by 조성민 on 4/14/24.
//

import RxSwift

protocol SetNicknameUseCase {
    
    var repository: SignUpRepository { get }
    
    func execute(nickname: String) -> Observable<Bool>
    
}
