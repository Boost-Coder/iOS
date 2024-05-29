//
//  DefaultSignUpRepository.swift
//  RankIn
//
//  Created by 조성민 on 4/13/24.
//

import Alamofire
import RxSwift

final class DefaultSignUpRepository: SignUpRepository {
    
    let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    func sejongLogin(loginInfo: SejongLoginInfo) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            self.session.request(RankInAPI.sejongLogin(SejongLoginInfoDTO: SejongLoginInfoDTO(
                id: loginInfo.id, pw: loginInfo.pw
            )), interceptor: AuthManager())
            .responseDecodable(of: SejongLoginResultDTO.self) { response in
                
                print("--------------------------------------------------------------------------------")
                print("* REQUEST URL: \(String(describing: response.request))")
                
                // reponse data 출력하기
                if
                    let data = response.data,
                    let utf8Text = String(data: data, encoding: .utf8) {
                    print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                }
                print("--------------------------------------------------------------------------------")
                
                switch response.result {
                case .success(let data):
                    observer.onNext(data.isAuthorized)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func setNickname(nickname: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let userID = KeyChainManager.read(storeElement: .userID) {
                self.session.request(
                    RankInAPI.setNickname(
                        userID: userID, nicknameDTO: NicknameDTO(nickname: nickname)
                    ),
                    interceptor: AuthManager()
                )
                .response(completionHandler: { response in
                    
                    print("--------------------------------------------------------------------------------")
                    print("* REQUEST URL: \(String(describing: response.request))")
                    
                    // reponse data 출력하기
                    if let data = response.data,
                       let utf8Text = String(data: data, encoding: .utf8) {
                        print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                    }
                    print("--------------------------------------------------------------------------------")
                    
                    switch response.result {
                    case .success:
                        observer.onNext(true)
                    case .failure(let error):
                        if error.responseCode == 409 {
                            observer.onNext(false)
                        } else {
                            observer.onError(error)
                        }
                    }
                })
            } else {
                observer.onError(RepositoryError.noUserID)
            }
            
            return Disposables.create()
        }
    }
    
    func setGrade(grade: Double) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            self.session.request(
                RankInAPI.setGrade(
                    gradeDTO: GradeDTO(grade: grade)
                ),
                interceptor: AuthManager()
            )
            .response(completionHandler: { response in
                
                print("--------------------------------------------------------------------------------")
                print("* REQUEST URL: \(String(describing: response.request))")
                
                // reponse data 출력하기
                if let data = response.data,
                   let utf8Text = String(data: data, encoding: .utf8) {
                    print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                }
                print("--------------------------------------------------------------------------------")
                
                switch response.result {
                case .success:
                    observer.onNext(())
                case .failure(let error):
                    if let underlyingError = error.underlyingError as? NSError,
                       underlyingError.code == URLError.notConnectedToInternet.rawValue {
                        observer.onError(ErrorToastCase.internetError)
                    } else if let underlyingError = error.underlyingError as? NSError,
                              underlyingError.code == 13 {
                        observer.onError(ErrorToastCase.serverError)
                    } else {
                        observer.onError(ErrorToastCase.clientError)
                    }
                }
            })
            
            return Disposables.create()
        }
    }
    
    func gitHubAuthorization(code: String) -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            
            if let clientID = Bundle.main.object(forInfoDictionaryKey: "GITHUB_CLIENT_ID") as? String,
               let clientSecret = Bundle.main.object(forInfoDictionaryKey: "GITHUB_CLIENT_SECRET") as? String {
                self.session.request(
                    RankInAPI.gitHubAuthorization(clientIdentifierDTO: ClientIdentifierDTO(
                        clientID: clientID,
                        clientSecret: clientSecret,
                        code: code
                    ))
                )
                .response(completionHandler: { response in
                    
                    print("--------------------------------------------------------------------------------")
                    print("* REQUEST URL: \(String(describing: response.request))")
                    
                    // reponse data 출력하기
                    if let data = response.data,
                       let utf8Text = String(data: data, encoding: .utf8) {
                        print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                    }
                    print("--------------------------------------------------------------------------------")
                    
                    switch response.result {
                    case .success(let data):
                        guard let data = data,
                              let stringData = String(data: data, encoding: .utf8),
                              let gitHubAccessTokenDTO = self.decodeQueryString(
                                stringData, to: GitHubAccessTokenDTO.self
                              ) else {
                            observer.onError(RepositoryError.gitHubAccessTokenWrongParsing)
                            return
                        }
                        KeyChainManager.create(
                            storeElement: .gitHubAccessToken,
                            content: gitHubAccessTokenDTO.accessToken
                        )
                        observer.onNext(gitHubAccessTokenDTO.accessToken)
                    case .failure(let error):
                        if let underlyingError = error.underlyingError as? NSError,
                           underlyingError.code == URLError.notConnectedToInternet.rawValue {
                            observer.onError(ErrorToastCase.internetError)
                        } else if let underlyingError = error.underlyingError as? NSError,
                                  underlyingError.code == 13 {
                            observer.onError(ErrorToastCase.serverError)
                        } else {
                            observer.onError(ErrorToastCase.clientError)
                        }
                    }
                })
            } else {
                observer.onError(RepositoryError.noGitHubClientInformation)
            }
            
            return Disposables.create()
        }
    }
    
    func registerGitHubAuthorization(code: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.session.request(
                RankInAPI.registerGitHubAuthorization(
                    gitHubAuthorizationDTO: GitHubAuthorizationDTO(
                        accessToken: code
                    )
                ),
                interceptor: AuthManager()
            )
            .response { response in
                
                print("--------------------------------------------------------------------------------")
                print("* REQUEST URL: \(String(describing: response.request))")
                
                // reponse data 출력하기
                if let data = response.data,
                   let utf8Text = String(data: data, encoding: .utf8) {
                    print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                }
                print("--------------------------------------------------------------------------------")
                
                switch response.result {
                case .success:
                    observer.onNext(true)
                case .failure(let error):
                    if let underlyingError = error.underlyingError as? NSError,
                       underlyingError.code == URLError.notConnectedToInternet.rawValue {
                        observer.onError(ErrorToastCase.internetError)
                    } else if let underlyingError = error.underlyingError as? NSError,
                              underlyingError.code == 13 {
                        observer.onError(ErrorToastCase.serverError)
                    } else {
                        observer.onError(ErrorToastCase.clientError)
                    }
                    
                }
            }
            
            return Disposables.create()
        }
    }
    
    func setBaekjoonID(id: String) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            self.session.request(
                RankInAPI.setBaekjoonID(
                    baekjoonDTO: BaekjoonDTO(bojID: id)
                ),
                interceptor: AuthManager()
            )
            .response(completionHandler: { response in
                
                print("--------------------------------------------------------------------------------")
                print("* REQUEST URL: \(String(describing: response.request))")
                
                // reponse data 출력하기
                if let data = response.data,
                   let utf8Text = String(data: data, encoding: .utf8) {
                    print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                }
                print("--------------------------------------------------------------------------------")
                
                switch response.result {
                case .success:
                    observer.onNext(())
                case .failure(let error):
                    if let underlyingError = error.underlyingError as? NSError,
                       underlyingError.code == URLError.notConnectedToInternet.rawValue {
                        observer.onError(ErrorToastCase.internetError)
                    } else if let underlyingError = error.underlyingError as? NSError,
                              underlyingError.code == 13 {
                        observer.onError(ErrorToastCase.serverError)
                    } else {
                        observer.onError(ErrorToastCase.clientError)
                    }
                }
            })
            
            return Disposables.create()
        }
    }
    
}

private extension DefaultSignUpRepository {
    
    func decodeQueryString<T: Decodable>(_ queryString: String, to type: T.Type) -> T? {
        var components = URLComponents()
        components.query = queryString
        
        guard let queryItems = components.queryItems else {
            return nil
        }
        
        var values: [String: String] = [:]
        
        for item in queryItems {
            values[item.name] = item.value
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: values, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: jsonData)
        } catch {
            print("Error decoding: \(error)")
            return nil
        }
    }
    
}
