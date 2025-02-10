//
//  TokenLoader.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 8.02.2025.
//

import Foundation
protocol fetchOAuthTokenLoading {
    func fetchOAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void)
}

struct TokenLoader: fetchOAuthTokenLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
    private let tokenStorage = OAuth2TokenStorage()
    init(networkClient: NetworkRouting = NetworkClient()){
        self.networkClient = networkClient
    }

    
    func fetchOAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        networkClient.fetch(code: code) { result in
            switch result {
            case .success(let data):
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    print(responseBody)
                    tokenStorage.token = responseBody.accessToken
                    completion(.success(responseBody))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
