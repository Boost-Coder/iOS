//
//  GitHubAccessTokenDTO.swift
//  RankIn
//
//  Created by 조성민 on 4/21/24.
//

import Foundation

struct GitHubAccessTokenDTO: Decodable {
    
    let accessToken: String
    let scope: String?
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
        case tokenType = "token_type"
    }
    
}
