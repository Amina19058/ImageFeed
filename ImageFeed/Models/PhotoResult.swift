//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 09.04.2025.
//

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Double
    let height: Double
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult

    struct UrlsResult: Decodable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
}

struct PhotoLikeResult: Decodable {
    let photo: PhotoResult
}
