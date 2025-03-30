//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 29.03.2025.
//

import Foundation

final class OAuth2TokenStorage {    
    static let shared = OAuth2TokenStorage()

    private init() {}
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token = "token"
    }

    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
