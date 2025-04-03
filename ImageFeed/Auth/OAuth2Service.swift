//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 29.03.2025.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let unsplashTokenURLString = "https://unsplash.com/oauth/token"

    private let oAuth2TokenStorage = OAuth2TokenStorage.shared

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private let decoder = JSONDecoder()

    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Failed to create token request")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }

        let task = urlSession.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let data):
                    do {
                        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let token = try self.decoder.decode(OAuthTokenResponseBody.self, from: data).accessToken
                        self.oAuth2TokenStorage.token = token
                        completion(.success(token))
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    print("Network error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastCode = nil
            }
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: unsplashTokenURLString) else {
            print("Invalid unsplashTokenURLString: \(unsplashTokenURLString)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("Couldn't create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
