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
    private var paginationFlag = true
    
    init(session: Session) {
        self.session = session
    }
    
    func fetchRankList() -> Observable<[RankTableViewCellContents]> {
        return Observable<[RankTableViewCellContents]>.create { observer -> Disposable in
            if !self.paginationFlag {
                observer.onNext(self.rankList)
                observer.onCompleted()
                return Disposables.create()
            }
            
            if let lastRank = self.rankList.last {
                self.session.request(RankInAPI.fetchRankList(
                    fetchRankComponentsDTO: FetchRankComponentsDTO(
                        major: nil,
                        cursorPoint: lastRank.score,
                        cursorUserID: lastRank.userID
                    )), interceptor: AuthManager())
                .responseDecodable(of: [RankDTO].self) { response in
                    
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
                        var ranks = data.map{ $0.toEntity() }
                        if ranks.isEmpty {
                            self.paginationFlag = false
                        } else {
                            self.rankList.append(contentsOf: ranks)
                            observer.onNext(self.rankList)
                        }
                    case .failure(let error):
                        dump(error)
                        observer.onError(error)
                    }
                }
            } else {
                self.session.request(RankInAPI.fetchRankList(fetchRankComponentsDTO: nil), interceptor: AuthManager())
                    .responseDecodable(of: [RankDTO].self) { response in
                        
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
    
    func fetchMyRank() -> Observable<UserRank> {
        return Observable<UserRank>.create { observer -> Disposable in
            guard let userID = KeyChainManager.read(storeElement: .userID) else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.session.request(RankInAPI.fetchUserRank(userDTO: UserDTO(userID: userID)), interceptor: AuthManager())
                .responseDecodable(of: UserRankDTO.self) { response in
                    
                    print("--------------------------------------------------------------------------------")
                    print("* REQUEST URL: \(String(describing: response.request))")
                    
                    // reponse data 출력하기
                    if let data = response.data,
                       let utf8Text = String(data: data, encoding: .utf8) {
                        print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
                    }
                    print("--------------------------------------------------------------------------------")
                    
                    switch response.result {
                    case .success(let dto):
                        observer.onNext(dto.toEntity())
                        observer.onCompleted()
                    case .failure(let error):
                        dump(error)
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func versus(row: Int) -> Observable<Versus> {
        
        return Observable<Versus>.create { observer -> Disposable in
            guard let user1 = KeyChainManager.read(storeElement: .userID), let user2 = self.rankList[safe: row]?.userID
            else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            self.session.request(
                RankInAPI.versus(
                    compareDTO: CompareDTO(
                        user1: user1, user2: user2
                    )
                ),
                interceptor: AuthManager()
            )
            .responseDecodable(of: VersusDTO.self) { response in
                switch response.result {
                case .success(let dto):
                    observer.onNext(dto.toEntity())
                    observer.onCompleted()
                case .failure(let error):
                    dump(error)
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
}
