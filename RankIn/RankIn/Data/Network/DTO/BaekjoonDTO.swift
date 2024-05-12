//
//  BaekjoonDTO.swift
//  RankIn
//
//  Created by 조성민 on 5/12/24.
//

import Foundation

struct BaekjoonDTO: Encodable {
    
    let bojID: String
    
    enum CodingKeys: String, CodingKey {
        
        case bojID = "bojId"
        
    }
    
}
