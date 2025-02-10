//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 8.02.2025.
//

import Foundation
protocol NetworkRouting {
    func fetch(code: String, completion: @escaping (Result<Data, Error>) -> Void)
}
struct NetworkClient: NetworkRouting {
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseUrl = URL(string: "https://unsplash.com/oauth/token") else {
          //  fatalError("Invalid URL")
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
            return nil
        }
        request.httpBody = httpBody
       return request
    }

    private enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
    
    func fetch(code: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NSError(domain: "OAuth2Service", code: 1, userInfo: [NSLocalizedDescriptionKey: "Не удалось сформировать запрос"])))
            return
        }
        print("старт")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("финиш")
            if let error = error {
                completion(.failure(NetworkError.urlRequestError(error)))
                print("error1111!!!!!")
                return
            } else {
                completion(.failure(NetworkError.urlSessionError))
                print("error222!!!!!")
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                print("error3333!!!!!")
                completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                return
            }
            guard let data = data else { return }
            completion(.success(data))
        }
        task.resume()
    }
}

