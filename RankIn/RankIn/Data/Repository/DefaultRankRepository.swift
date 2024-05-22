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
    
    func fetchRankList() -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            self.session.request(RankInAPI.fetchRankList, interceptor: AuthManager())
                .responseDecodable(of: [RankDTO].self) { response in
                    
                    print("* REQUEST URL: \(String(describing: response.request))")
                    
                    // reponse data 출력하기
                    if
                        let data = response.data,
                        let utf8Text = String(data: data, encoding: .utf8) {
                        print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                    }
                    
                    switch response.result {
                    case .success(let data):
                        self.rankList = data.map{ $0.toEntity() }
                        observer.onNext(())
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func getRankCellContents() -> Observable<[RankTableViewCellContents]> {
        return .just(self.rankList)
    }
    
}
