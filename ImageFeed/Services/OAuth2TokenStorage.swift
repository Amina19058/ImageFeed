//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 29.03.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {    
    static let shared = OAuth2TokenStorage()

    private init() {}
    
    private let storage: KeychainWrapper = .standard
    
    private enum Keys: String {
        case token = "token"
    }

    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue else {
                print("Failed to set new token value: token is nil")
                return
            }
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    func clearToken() {
        storage.removeObject(forKey: Keys.token.rawValue)
    }
}
