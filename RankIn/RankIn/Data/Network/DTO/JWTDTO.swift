//
//  JWTDTO.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import Foundation

struct JWTDTO: Decodable {
    
    let accessToken: String
    let refreshToken: String
    
}
