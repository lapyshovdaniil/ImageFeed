//
//  URLsession+Data.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 11.02.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulFillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulFillCompletionOnTheMainThread(.success(data))
                    
                } else {
                    print("Ошибка! Код ответа сервера: \(statusCode)")
                    fulFillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("Ошибка: \(error)")
                fulFillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("Ошибка NetworkError.urlSessionError")
                fulFillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
    
}
//extension URLSession {
//    func objectTask<T: Decodable>(
//        for request: URLRequest,
//        completion: @escaping (Result<T, Error>) -> Void
//    ) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        let task = data(for: request) { (result: Result<Data, Error>) in
//            
//            
//            
//            
//            // TODO [Sprint 11] Напишите реализацию c декодированием Data в тип T
//        }
//        return task
//    }
//}

