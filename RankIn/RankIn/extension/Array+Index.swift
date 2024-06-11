//
//  Array+Index.swift
//  RankIn
//
//  Created by 조성민 on 6/12/24.
//

import Foundation

extension Array {
    subscript (safe index: Array.Index) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            guard let element = newValue else { return }
            self[index] = element
        }
    }
}
