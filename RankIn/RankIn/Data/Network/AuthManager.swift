//
//  AuthManager.swift
//  RankIn
//
//  Created by 조성민 on 4/4/24.
//

import Alamofire

enum AuthError: Error {
    
    case noToken
    
}

final class AuthManager: RequestInterceptor {
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        guard let accessToken = KeyChainManager.read(storeElement: .accessToken) else {
            completion(.failure(AuthError.noToken))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        guard let refreshToken = KeyChainManager.read(storeElement: .refreshToken) else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        session
            .request(RankInAPI.requestAccessToken(refreshToken: refreshToken))
            .responseDecodable(of: JWTDTO.self) { response in
                switch response.result {
                case .success(let data):
                    KeyChainManager.create(storeElement: .accessToken, content: data.accessToken)
                    KeyChainManager.create(storeElement: .refreshToken, content: data.refreshToken)
                    completion(.retry)
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                }
            }
    }
    
}
