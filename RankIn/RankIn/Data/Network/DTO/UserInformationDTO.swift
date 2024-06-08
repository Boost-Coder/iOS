//
//  InformationDTO.swift
//  RankIn
//
//  Created by 조성민 on 6/8/24.
//

import Foundation

struct UserInformationDTO: Decodable {
    
    let userID: String
    let nickname: String
    let major: String
    let name: String
    let studentID: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname
        case major
        case name
        case studentID = "studentId"
    }
    
    func toEntity() -> UserInformation {
        return UserInformation(
            userID: self.userID,
            nickname: self.nickname,
            major: self.major,
            name: self.name,
            studentID: String(self.studentID)
        )
    }
    
}
