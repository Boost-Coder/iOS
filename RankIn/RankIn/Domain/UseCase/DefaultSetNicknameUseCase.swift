//
//  DefaultSetNicknameUseCase.swift
//  RankIn
//
//  Created by 조성민 on 4/14/24.
//

import RxSwift

struct DefaultSetNicknameUseCase: SetNicknameUseCase {
    
    let repository: SignUpRepository
    
    func execute(nickname: String) -> Observable<Bool> {
        return repository.setNickname(nickname: nickname)
    }
    
}
