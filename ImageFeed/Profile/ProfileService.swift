//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 03.04.2025.
//

import Foundation

enum ProfileServiceError: Error {
    case invalidRequest
    case alreadyFetched
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from profileReult: ProfileResult) {
        self.username = profileReult.username
        self.name = profileReult.firstName + (profileReult.lastName ?? "")
        self.loginName = "@" + profileReult.username
        self.bio = profileReult.bio
    }
}

final class ProfileService {
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    private let unsplashProfileURLString = UnsplashUrlStrings.profile

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastToken != token else {
            completion(.failure(ProfileServiceError.alreadyFetched))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileInfoRequest(token: token) else {
            print("[fetchProfile] Failed to create profile request")
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }

        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let profileResult):
                    let profile = Profile(from: profileResult)
                    self.profile = profile
                    completion(.success(profile))
                    
                case .failure(let error):
                    print("[fetchProfile] Network error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastToken = nil
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeProfileInfoRequest(token: String) -> URLRequest? {
        guard let url = URL(string: unsplashProfileURLString) else {
            print("[makeProfileInfoRequest] Invalid unsplashProfileURLString: \(unsplashProfileURLString)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = .HTTPMethod.get
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

extension ProfileService {
    func cleanProfile() {
        task?.cancel()
        task = nil
        profile = nil
        lastToken = nil
    }
}
