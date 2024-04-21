//
//  ResponseDTO.swift
//  RankIn
//
//  Created by 조성민 on 4/21/24.
//

import Foundation

struct ResponseDTO: Decodable {
    
    let statusCode: Int
    let path: String
    let message: String
    
}
