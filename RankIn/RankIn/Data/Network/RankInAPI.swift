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
    
}

// TODO: 실제 API가 나오면 모두 수정
extension RankInAPI: Router, URLRequestConvertible {
    
    var baseURL: String? {
        return nil
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var encoding: ParameterEncoding? {
        return nil
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
