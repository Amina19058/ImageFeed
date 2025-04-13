//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 05.04.2025.
//

import Foundation

enum ProfileImageServiceError: Error {
    case invalidRequest
}

struct UserResult: Decodable {
    let profileImage: ProfileImage

    struct ProfileImage: Decodable {
        let small: String
    }
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: .Notification.profileImageProviderDidChange)
    
    private let unsplashProfileImageURLString = UnsplashUrlStrings.profileImage
    
    private let urlSession = URLSession.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private(set) var avatarURL: String?
        
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = oAuth2TokenStorage.token else {
            print("[fetchProfileImageURL] Failed to get token from storage")
            assertionFailure("No token found")
            return
        }
        
        guard lastToken != token else {
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileInfoRequest(token: token, username: username) else {
            print("[fetchProfileImageURL] Failed to create profile request")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let profileImage):
                    let profileImageURL = profileImage.profileImage.small
                    self.avatarURL = profileImageURL
                    
                    completion(.success(profileImageURL))
                    
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profileImageURL])
                    
                case .failure(let error):
                    print("[fetchProfileImageURL] Network error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastToken = nil
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeProfileInfoRequest(token: String, username: String) -> URLRequest? {
        guard let url = URL(string: unsplashProfileImageURLString + username) else {
            print("[makeProfileInfoRequest] Invalid unsplashProfileURLString: \(unsplashProfileImageURLString)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = .HTTPMethod.get
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

extension ProfileImageService {
    func cleanProfileImage() {
        task?.cancel()
        task = nil
        lastToken = nil
        avatarURL = nil
    }
}
