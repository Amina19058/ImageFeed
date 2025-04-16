//
//  ImagesListServiceSpy.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import Foundation
@testable import ImageFeed

enum ImagesListServiceError: Error {
    case error
}

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    var photos: [ImageFeed.Photo] = []
    
    var fetchPhotosMockResult: Result<[Photo], Error>?
    var changeLikeMockResult: Result<Void, any Error>?
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let fetchPhotosMockResult else {
            completion(.failure(ImagesListServiceError.error))
            return
        }
        
        completion(fetchPhotosMockResult)
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let changeLikeMockResult else {
            completion(.failure(ImagesListServiceError.error))
            return
        }
        
        completion(changeLikeMockResult)
    }
    
    
}
