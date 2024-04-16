//
//  LoginResultDTO.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import Foundation

struct LoginResultDTO: Decodable {
    
    let accessToken: String
    let refreshToken: String
    let isMember: Bool
    let userID: Int
    
}
