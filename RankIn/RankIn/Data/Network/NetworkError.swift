//
//  NetworkError.swift
//  RankIn
//
//  Created by 조성민 on 3/30/24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    
    case wrongURL
    case wrongParameters
    
    var errorDescription: String {
        switch self {
        case .wrongURL:
            return "URL이 잘못되었습니다."
        case .wrongParameters:
            return "Parameters가 잘못되었습니다."
        }
    }
    
}

