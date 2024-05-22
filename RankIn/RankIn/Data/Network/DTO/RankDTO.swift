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
    let score: Int
    
    enum CodingKeys: String, CodingKey {
        case nickName = "nickname"
        case userID = "userId"
        case rank
        case score = "point"// TODO: 수정
    }
    
    func toEntity() -> RankTableViewCellContents {
        return RankTableViewCellContents(
            rank: rank, 
            nickName: nickName,
            score: score
        )
    }
    
}
