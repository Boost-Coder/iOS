//
//  FetchRankComponentsDTO.swift
//  RankIn
//
//  Created by 조성민 on 5/28/24.
//

import Foundation

struct FetchRankComponentsDTO: Encodable {
    
    let major: String?
    let cursorPoint: Int
    let cursorUserID: String
    
    enum CodingKeys: String, CodingKey {
        case major
        case cursorPoint
        case cursorUserID = "cursorUserId"
    }
    
    func toEntity() -> FetchRankComponents {
        return FetchRankComponents(
            major: major,
            cursorPoint: cursorPoint,
            cursorUserID: cursorUserID
        )
    }
    
}
