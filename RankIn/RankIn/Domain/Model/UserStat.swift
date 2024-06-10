//
//  UserStat.swift
//  RankIn
//
//  Created by 조성민 on 6/11/24.
//

import Foundation

struct UserStat {
    
    let githubPoint: Double
    let algorithmPoint: Double
    let grade: Double
    let totalPoint: Double
    
    init(
        githubPoint: Double,
        algorithmPoint: Double,
        grade: Double,
        totalPoint: Double
    ) {
        self.githubPoint = githubPoint
        self.algorithmPoint = algorithmPoint
        self.grade = grade
        self.totalPoint = totalPoint
    }
    
    init(
        githubPoint: String,
        algorithmPoint: String,
        grade: Double,
        totalPoint: String
    ) {
        self.githubPoint = Double(githubPoint) ?? 0
        self.algorithmPoint = Double(algorithmPoint) ?? 0
        self.grade = grade
        self.totalPoint = Double(totalPoint) ?? 0
    }
    
}
