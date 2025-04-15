//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 09.04.2025.
//

import Foundation

enum ImagesListServiceError: Error {
    case invalidRequest
    case alreadyFetching
}

struct Photo {
    private let dateFormatter = ISO8601DateFormatter()
    
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.createdAt = dateFormatter.date(from: photoResult.createdAt)
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.raw
        self.isLiked = photoResult.likedByUser
    }
}

final class ImagesListService {
    static let shared = ImagesListService()
    
    private let unsplashPhotosURLString = UnsplashUrlStrings.photos
    
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int
    
    private let urlSession = URLSession.shared
    private var fetchTask: URLSessionTask?
    private var likeTask: URLSessionTask?

    static let didChangeNotification = Notification.Name(rawValue: .Notification.imagesListServiceDidChange)
    
    private init() {
        lastLoadedPage = .zero
    }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        if fetchTask != nil {
            print("[fetchPhotosNextPage] Previous fetch is still in progress")
            completion(.failure(ImagesListServiceError.alreadyFetching))
            return
        }
        
        let nextPage = lastLoadedPage + 1
        
        guard let request = makePhotosRequest(page: nextPage) else {
            print("[fetchPhotosNextPage] Failed to create photos request")
            completion(.failure(ImagesListServiceError.invalidRequest))
            return
        }

        let fetchTask = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photosResult):
                for photoResult in photosResult {
                    let photo = Photo(from: photoResult)
                    photos.append(photo)
                }
                
                NotificationCenter.default
                    .post(name: ImagesListService.didChangeNotification,
                        object: self)
                
                lastLoadedPage = nextPage
                
                completion(.success(photos))
                
            case .failure(let error):
                print("[fetchPhotosNextPage] Failed to fetch photos: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.fetchTask = nil
        }
        
        self.fetchTask = fetchTask
        fetchTask.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if likeTask != nil {
            print("[changeLike] Previous like task is still in progress")
            return
        }
        
        likeTask?.cancel()
        
        guard let request = makeChangeLikeRequest(photoId: photoId, isLike: isLike) else {
            print("[changeLike] Failed to create like request")
            return
        }

        let likeTask = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photoLikeResult):
                let changedPhoto = Photo(from: photoLikeResult.photo)
                
                for (insex, photo) in self.photos.enumerated() {
                    if photo.id == changedPhoto.id {
                        self.photos[insex] = changedPhoto
                    }
                }
                
                completion(.success(()))
                
                NotificationCenter.default
                    .post(name: ImagesListService.didChangeNotification,
                        object: self)
                            
            case .failure(let error):
                print("[changeLike] Failed to change like: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.likeTask = nil
        }
        
        self.likeTask = likeTask
        likeTask.resume()
    }
    
    private func makePhotosRequest(page: Int, perPage: Int = 10) -> URLRequest? {
        guard var urlComponents = URLComponents(string: unsplashPhotosURLString) else {
            print("[makePhotosRequest] Invalid unsplashPhotosURLString: \(unsplashPhotosURLString)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: page.description),
            URLQueryItem(name: "per_page", value: perPage.description)
        ]
        
        guard let url = urlComponents.url else {
            print("[makePhotosRequest] Couldn't create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = .HTTPMethod.get
        
        guard let token = OAuth2TokenStorage.shared.token else {
            assertionFailure("No token found")
            return nil
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func makeChangeLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        let urlString = "\(unsplashPhotosURLString)/\(photoId)/like"
        
        guard let url = URL(string: urlString) else {
            print("[makeChangeLikeRequest] Couldn't create URL from: \(urlString)")
            return nil
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = isLike ? .HTTPMethod.post : .HTTPMethod.delete
        
        guard let token = OAuth2TokenStorage.shared.token else {
            assertionFailure("No token found")
            return nil
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

extension ImagesListService {
    func cleanImages() {
        photos = []
        lastLoadedPage = .zero
        
        fetchTask?.cancel()
        fetchTask = nil
        
        likeTask?.cancel()
        likeTask = nil
    }
}
