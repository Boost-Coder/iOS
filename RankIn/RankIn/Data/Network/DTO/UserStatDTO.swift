//
//  UserStatDTO.swift
//  RankIn
//
//  Created by 조성민 on 6/11/24.
//

import Foundation

struct UserStatDTO: Decodable {
    
    let githubPoint: String
    let algorithmPoint: String
    let grade: Double
    let totalPoint: String
    
    func toEntity() -> UserStat {
        return UserStat(
            githubPoint: githubPoint,
            algorithmPoint: algorithmPoint,
            grade: grade,
            totalPoint: totalPoint
        )
    }
    
}
