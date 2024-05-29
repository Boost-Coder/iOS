//
//  DefaultRankRepository.swift
//  RankIn
//
//  Created by 조성민 on 5/22/24.
//

import Alamofire
import RxSwift

final class DefaultRankRepository: RankRepository {
    
    let session: Session
    
    private var rankList: [RankTableViewCellContents] = []
    
    init(session: Session) {
        self.session = session
    }
    
    func fetchRankList(fetchRankComponents: FetchRankComponents? = nil) -> Observable<[RankTableViewCellContents]> {
        return Observable<[RankTableViewCellContents]>.create { observer -> Disposable in

            if let fetchRankComponents = fetchRankComponents {
                self.session.request(RankInAPI.fetchRankList(
                    fetchRankComponentsDTO: FetchRankComponentsDTO(
                        major: fetchRankComponents.major,
                        cursorPoint: fetchRankComponents.cursorPoint,
                        cursorUserID: fetchRankComponents.cursorUserID
                    )), interceptor: AuthManager())
                .responseDecodable(of: [RankDTO].self) { response in
                    
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
                        self.rankList.append(contentsOf: data.map{ $0.toEntity() })
                        observer.onNext(self.rankList)
                    case .failure(let error):
                        dump(error)
                        observer.onError(error)
                    }
                }
            } else {
                self.session.request(RankInAPI.fetchRankList(
                    fetchRankComponentsDTO: nil
                ), interceptor: AuthManager())
                .responseDecodable(of: [RankDTO].self) { response in
                    
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
                        self.rankList.append(contentsOf: data.map{ $0.toEntity() })
                        observer.onNext(self.rankList)
                    case .failure(let error):
                        dump(error)
                        observer.onError(error)
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
}
