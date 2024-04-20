//
//  GitHubAccessTokenDTO.swift
//  RankIn
//
//  Created by 조성민 on 4/21/24.
//

import Foundation

struct GitHubAccessTokenDTO: Decodable {
    
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
    
}
