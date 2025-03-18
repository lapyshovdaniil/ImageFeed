//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 11.03.2025.
//
import Foundation

final class ImagesListService {
    
    enum HttpMetods {
        static let post = "POST"
        static let delete = "DELETE"
    }
    
    static let shared = ImagesListService()
    private init() {}
    
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let tokenStorage = OAuth2TokenStorage()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func clear() {
        self.photos = []
    }
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
    private func deleteAndWriteLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        guard let defaultBaseURL = Constants.defaultBaseURL else {
            print("Invalid URL")
            assertionFailure("Failed to create URL")
            return nil
        }
        let endPoint = "photos/\(photoId)/like"
        let fullURL = defaultBaseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: fullURL)
        request.httpMethod = isLike ? HttpMetods.post : HttpMetods.delete
            guard let token = tokenStorage.getBearerToken() else {
            print("No token found")
            return nil
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if let task = task, task.state == .running {
            task.cancel()
        }
        let nextPage = (lastLoadedPage ?? 0) + 1
    
        guard let request = makePhotosRequest(page: nextPage) else {
            print("❌ Некорректный request")
            return
        }
        let task = URLSession.shared.objectTask(for: request) {
            (result: Result<[PhotoResult], Error>) in
            
            switch result {
            case .success(let data):
                let photosJson = data.map { $0.asPhoto }
                    let newPhotos = photosJson.filter { newPhoto in
                        !self.photos.contains(where: { $0.id == newPhoto.id })
                    }
                    if !newPhotos.isEmpty {
                        self.photos.append(contentsOf: newPhotos)
                        self.lastLoadedPage = (self.lastLoadedPage ?? 0) + 1
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self, userInfo: ["Photos": newPhotos])
                    }
            case .failure(let error):
                print("Ошибка! Неудалось получить данные: \(error)")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void){
        guard let request = deleteAndWriteLikeRequest(photoId: photoId, isLike: isLike) else {
            completion(
                .failure(
                    NSError(
                        domain: "ImagesListService", code: 1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Запрос не сформирован"
                        ])))
            return
        }
        let task = URLSession.shared.objectTask(for: request){
            (result: Result<PhotoResponse, Error>) in
            switch result {
            case .success(let data):
                print("\(data.photo.likedByUser)")
                if let index = self.photos.firstIndex(where: {$0.id == photoId}){
                    let photo = self.photos[index]
                    print("\(photo)")
                    let newPhoto = Photo(
                        id: photo.id,
                        size: photo.size,
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.welcomeDescription,
                        thumbImageURL: photo.thumbImageURL,
                        largeImageURL: photo.largeImageURL,
                        fullImageUrl: photo.fullImageUrl,
                        isLiked: !photo.isLiked
                    )
                    if index >= 0 && index < self.photos.count {
                        self.photos[index] = newPhoto
                    }
        completion(.success(()))
                }
            case .failure(let error):
                print("Ошибка! Неудалось получить данные: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
