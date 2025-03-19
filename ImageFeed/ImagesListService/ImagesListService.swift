//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 11.03.2025.
//
import Foundation

final class ImagesListService {
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let tokenStorage = OAuth2TokenStorage()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private func makePhotosRequest(page: Int) -> URLRequest? {
        guard let defaultBaseURL = Constants.defaultBaseURL else {
            print("Invalid URL")
            assertionFailure("Failed to create URL")
            return nil
        }
        let endPoint = "/photos"
        var urlComponents = URLComponents(url: defaultBaseURL.appendingPathComponent(endPoint), resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let fullURL = urlComponents?.url else {
            print("Failed to create URL with query parameters")
            return nil
        }
        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        guard let token = tokenStorage.getBearerToken() else {
            print("No token found")
            return nil
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        return request
    }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        if let task = task, task.state == .running {
            task.cancel()
        }
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let request = makePhotosRequest(page: nextPage) else {
            completion(
                .failure(
                    NSError(
                        domain: "ImagesListService", code: 1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Запрос не сформирован"
                        ])))
            return
        }
        let task = URLSession.shared.objectTask(for: request) {
            (result: Result<[PhotoResult], Error>) in
            
            switch result {
            case .success(let data):
                let photosJson = transformPhotoResultsToPhotos(photoResults: data)
                self.photos.append(contentsOf: photosJson)
                completion(.success(photosJson))
                print(photosJson)
                
            case .failure(let error):
                print("Ошибка! Неудалось получить данные: \(error)")
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}
