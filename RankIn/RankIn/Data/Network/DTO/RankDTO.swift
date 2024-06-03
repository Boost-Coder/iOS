//
//  RankDTO.swift
//  RankIn
//
//  Created by 조성민 on 5/22/24.
//

import Foundation

struct RankDTO: Decodable {
    
    let nickName: String
    let userID: String
    let rank: Int
    let score: Double
    
    enum CodingKeys: String, CodingKey {
        case nickName = "nickname"
        case userID = "userId"
        case rank
        case score
    }
    
    func toEntity() -> RankTableViewCellContents {
        return RankTableViewCellContents(
            userID: userID,
            rank: rank, 
            nickName: nickName,
            score: score
        )
    }
    
}
