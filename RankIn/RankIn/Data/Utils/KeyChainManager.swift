//
//  KeyChainManager.swift
//  RankIn
//
//  Created by 조성민 on 4/4/24.
//

import Foundation

final class KeyChainManager {
    
    enum StoreElement: String {
        
        case accessToken
        case refreshToken
        case userID
        case gitHubAccessToken
        
    }
    
    static func create(storeElement: StoreElement, content: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: storeElement.rawValue,
            kSecValueData: content.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "failed to save Token")
    }
    
    static func read(storeElement: StoreElement) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: storeElement.rawValue,
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
    
    static func delete(storeElement: StoreElement) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: storeElement.rawValue
        ]
        let status = SecItemDelete(query)
        assert(status == noErr, "failed to delete the value, status code = \(status)")
    }

}
