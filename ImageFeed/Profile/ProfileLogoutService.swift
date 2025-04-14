//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 12.04.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let prifileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared

    private init() { }
    
    func logout() {
        cleanCookies()
        oAuth2TokenStorage.cleanToken()
        prifileService.cleanProfile()
        profileImageService.cleanProfileImage()
        imagesListService.cleanImages()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
    
