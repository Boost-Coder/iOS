//
//  ClientIdentifierDTO.swift
//  RankIn
//
//  Created by 조성민 on 4/18/24.
//

import Foundation

struct ClientIdentifierDTO: Encodable {
    
    let clientID: String
    let clientSecret: String
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case code
    }
    
}
