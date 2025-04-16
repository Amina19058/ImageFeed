//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 15.04.2025.
//

import Foundation

enum Constants {
    static let accessKey = "OZHrlUzJ1u1KmlqhgUNgsq4wZZRyAz0w3Wm2QyknfYg"
    static let secretKey = "_YvMrBEuNYkDlMKNIS39Ximp06X6J8d6BihIeqAP85g"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

enum UnsplashUrlStrings {
    static let token = "https://unsplash.com/oauth/token"
    static let authorize = "https://unsplash.com/oauth/authorize"
    static let profile = "https://api.unsplash.com/me"
    static let profileImage = "https://api.unsplash.com/users/"
    static let photos = "https://api.unsplash.com/photos"

}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }

}
