//
//  KeyChainManager.swift
//  RankIn
//
//  Created by 조성민 on 4/4/24.
//

import Foundation

final class KeyChainManager {
    
    enum Token: String {
        
        case access
        case refresh
        
    }
    
    static let serviceName = "RankIn"
    
    static func create(token: Token, content: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: token.rawValue,
            kSecValueData: content.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "failed to save Token")
    }
    
    static func read(token: Token) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: token.rawValue,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess, let retrievedData = dataTypeRef as? Data {
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else {
            print("failed to loading, status code = \(status)")
            return nil
        }
    }
    
    static func delete(token: Token) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: token.rawValue
        ]
        let status = SecItemDelete(query)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }

}
