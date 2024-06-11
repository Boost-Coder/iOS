//
//  UserRankDTO.swift
//  RankIn
//
//  Created by 조성민 on 6/12/24.
//

import Foundation

struct UserRankDTO: Decodable {
    
    let total: String
    let algorithm: String
    let github: String
    let grade: String
    let totalScore: String
    let algorithmScore: String
    let githubScore: String
    let gradeScore: String
    let nickname: String
    
    func toEntity() -> UserRank {
        return UserRank(
            nickname: nickname,
            github: github,
            algorithm: algorithm,
            grade: grade,
            total: total,
            githubScore: githubScore,
            algorithmScore: algorithmScore,
            gradeScore: gradeScore,
            totalScore: totalScore
        )
    }
    
}
