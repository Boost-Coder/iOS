//
//  LoginResultDTO.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import Foundation

struct LoginResultDTO: Decodable {
    
    // TODO: userID Int로 변경해야 함
    let accessToken: String
    let refreshToken: String
    let isMember: Bool
    let userID: String
//    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case isMember
        case userID = "userId"
    }
    
}
