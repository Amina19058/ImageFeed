//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 29.03.2025.
//

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
