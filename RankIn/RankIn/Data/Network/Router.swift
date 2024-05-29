//
//  Router.swift
//  RankIn
//
//  Created by 조성민 on 3/30/24.
//

import Alamofire

protocol Router {
    
    var baseURL: String? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
    var encoding: ParameterEncoding? { get }
    
}
