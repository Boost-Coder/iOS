//
//  ViewModel.swift
//  RankIn
//
//  Created by 조성민 on 3/27/24.
//

import RxRelay

protocol ViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
