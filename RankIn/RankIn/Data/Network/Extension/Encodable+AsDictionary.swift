//
//  Encodable+AsDictionary.swift
//  RankIn
//
//  Created by 조성민 on 3/31/24.
//

import Foundation

extension Encodable {
    
    func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            ) as? [String: Any]
            return dictionary
        } catch {
            return nil
        }
    }
    
}
