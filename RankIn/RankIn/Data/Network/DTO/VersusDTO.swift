//
//  VersusDTO.swift
//  RankIn
//
//  Created by 조성민 on 6/12/24.
//

import Foundation

struct VersusDTO: Decodable {
    
    let algorithmScoreDifference: Double?
    let algorithmRankDifference: Int?
    let githubScoreDifference: Double?
    let githubRankDifference: Int?
    let gradeScoreDifference: Double?
    let gradeRankDifference: Int?
    let totalScoreDifference: Double?
    let totalRankDifference: Int?
    let mostSignificantScoreDifferenceStat: String?
    
    func toEntity() -> Versus {
        return Versus(
            algorithmScoreDifference: algorithmScoreDifference,
            algorithmRankDifference: algorithmRankDifference,
            githubScoreDifference: githubScoreDifference,
            githubRankDifference: githubRankDifference,
            gradeScoreDifference: gradeScoreDifference,
            gradeRankDifference: gradeRankDifference,
            totalScoreDifference: totalScoreDifference,
            totalRankDifference: totalRankDifference,
            mostSignificantScoreDifferenceStat: mostSignificantScoreDifferenceStat
        )
    }
    
}
