//
//  RankInAPI.swift
//  RankIn
//
//  Created by 조성민 on 3/30/24.
//

import RxSwift
import Alamofire

enum RankInAPI {
    
    case appleLogin(appleLoginDTO: AppleLoginDTO)
    case requestAccessToken(refreshToken: String)
    case sejongLogin(SejongLoginInfoDTO: SejongLoginInfoDTO)
    case setNickname(userID: String, nickname: String)
    case setGrade(userID: String, grade: String)
    
}

extension RankInAPI: Router, URLRequestConvertible {
    
    var baseURL: String? {
        return getURL()
    }
    
    var path: String {
        switch self {
        case .appleLogin:
            return "auth/apple"
        case .requestAccessToken:
            return "auth/refresh"
        case .sejongLogin:
            return "auth/sejong"
        case .setNickname(let userID, _), .setGrade(let userID, _):
            return "users/\(userID)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .appleLogin, .requestAccessToken, .sejongLogin:
            return .post
        case .setNickname, .setGrade:
            return .put
        }
    }
    
    var headers: [String: String] {
        switch self {
        default:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .appleLogin(let appleLoginDTO):
            return appleLoginDTO.asDictionary()
        case .requestAccessToken(let refreshToken):
            return refreshToken.asDictionary()
        case .sejongLogin(let sejongLoginInfoDTO):
            return sejongLoginInfoDTO.asDictionary()
        case .setNickname(_, let nickname):
            return nickname.asDictionary()
        case .setGrade(_, let grade):
            return grade.asDictionary()
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .appleLogin, .requestAccessToken, .sejongLogin, .setNickname, .setGrade:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let base = baseURL,
              let url = URL(string: base + path) else {
            throw NetworkError.wrongURL
        }
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        if let encoding = encoding {
            if let parameters = parameters {
                return try encoding.encode(request, with: parameters)
            } else {
                throw NetworkError.wrongParameters
            }
        }
        
        return request
    }
    
}

private extension RankInAPI {
    
    func getURL() -> String? {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "DEV_SERVER_URL") as? String else { return nil }
        return url
    }
    
}
