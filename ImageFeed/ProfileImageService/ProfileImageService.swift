//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 1.03.2025.
//
import UIKit

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    
    private let tokenStorage = OAuth2TokenStorage()
    
    static let shared = ProfileImageService()
    private init() {}
    
    private func makeProfileRequest(username: String) -> URLRequest? {
        guard let defaultBaseURL = Constants.defaultBaseURL else {
            print("Invalid URL")
            assertionFailure("Failed to create URL")
            return nil
        }
        let endPoint = "users/\(username)"
        let fullURL = defaultBaseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        guard let token = tokenStorage.getBearerToken() else {
            return nil
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    private func  updateProfileDetails(newProfileImage: String){
        self.avatarURL = newProfileImage
     }
    
    func fetсhImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeProfileRequest(username: username) else {
            completion(.failure(NSError(domain: "ProfileService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Запрос не сформирован"])))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<ProfileImageResult, Error>) in
            switch result {
            case .success(let data):
                    self.updateProfileDetails(newProfileImage: data.profileImage.small)
                    guard let avatarURL = self.avatarURL else {
                        return
                    }
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL" : avatarURL])
                    completion(.success(data.profileImage.small))
            case .failure(let error):
                    print("Ошибка! Неудалось получить данные: \(error)")
                    completion(.failure(error))
//                self.task = nil
//                self.lastcode = nil
            }
        }
        task.resume()
    }
}
