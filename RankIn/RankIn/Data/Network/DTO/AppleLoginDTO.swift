//
//  AppleLoginDTO.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import Foundation

struct AppleLoginDTO: Encodable {
    
    let identityToken: String
    let authorizationCode: String
    
}
