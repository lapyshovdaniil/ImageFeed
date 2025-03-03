//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 8.02.2025.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private init() {}
    
    
//    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastcode: String?
    
    private let tokenStorage = OAuth2TokenStorage()
    
    enum AuthServiceError: Error {
        case invalidRequest
    }

    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseUrl = URL(string: "https://unsplash.com/oauth/token") else {
            print("Invalid URL")
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: "\(code)"),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let httpBody = urlComponents.query?.data(using: .utf8) else {
            print("Ошибка при преобразовании URLComponents")
            return nil
        }
        request.httpBody = httpBody
        return request
    }
    
    func fetch(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastcode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastcode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastcode = code
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NSError(domain: "OAuth2Service", code: 1, userInfo: [NSLocalizedDescriptionKey: "Запрос не сформирован"])))
            return
        }
        let task = URLSession.shared.data(for: request) { result in
          
            switch result {
            case .success(let data):
                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    print("Получен Bearer токен: \(response.accessToken)")
                    self.tokenStorage.token = response.accessToken
                    
                    completion(.success(response.accessToken))
                    
                } catch {
                    completion(.failure(NSError(domain: "OAuth2Service", code: 2, userInfo: [NSLocalizedDescriptionKey: "Ошибка JSON"])))
                    
                }
            case .failure(let error):
                    print("Ошибка! Неудалось получить токен: \(error)")
                    completion(.failure(error))
                self.task = nil
                self.lastcode = nil
            }
        }
        self.task = task
        task.resume()
    }
}

