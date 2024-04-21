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
    case requestAccessToken(refreshTokenDTO: RefreshTokenDTO)
    case sejongLogin(SejongLoginInfoDTO: SejongLoginInfoDTO)
    case setNickname(userID: String, nicknameDTO: NicknameDTO)
    case setGrade(gradeDTO: GradeDTO)
    case gitHubAuthorization(clientIdentifierDTO: ClientIdentifierDTO)
    case registerGitHubAuthorization(gitHubAuthorizationDTO: GitHubAuthorizationDTO)
    
}

extension RankInAPI: Router, URLRequestConvertible {
    
    var baseURL: String? {
        switch self {
        case .gitHubAuthorization:
            return "https://github.com"
        default:
            return getURL()
        }
    }
    
    var path: String {
        switch self {
        case .appleLogin:
            return "/auth/apple"
        case .requestAccessToken:
            return "/auth/refresh"
        case .sejongLogin:
            return "/auth/sejong"
        case .setNickname(let userID, _):
            return "/users/\(userID)"
        case .setGrade:
            return "/stat/grade"
        case .gitHubAuthorization:
            return "/login/oauth/access_token"
        case .registerGitHubAuthorization:
            return "/stat/github"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .appleLogin, .requestAccessToken, .sejongLogin, .setGrade, .gitHubAuthorization, .registerGitHubAuthorization:
            return .post
        case .setNickname:
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
        case .setNickname(_, let nicknameDTO):
            return nicknameDTO.asDictionary()
        case .setGrade(let gradeDTO):
            return gradeDTO.asDictionary()
        case .gitHubAuthorization(let clientIdentifierDTO):
            return clientIdentifierDTO.asDictionary()
        case .registerGitHubAuthorization(let gitHubAuthorizationDTO):
            return gitHubAuthorizationDTO.asDictionary()
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .appleLogin, .requestAccessToken, .sejongLogin, .setNickname, .setGrade, .gitHubAuthorization, .registerGitHubAuthorization:
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
