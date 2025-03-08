//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 24.02.2025.
//

import UIKit
final class ProfileService {
    
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: ProfileModel?
    
    private func makeProfileRequest(code: String) -> URLRequest? {
        guard let defaultBaseURL = Constants.defaultBaseURL else {
            print("Invalid URL")
            assertionFailure("Failed to create URL")
            return nil
        }
        let endPoint = "me"
        let fullURL = defaultBaseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(code)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func  updateProfileDetails(newProfile: ProfileModel){
        self.profile = newProfile
     }

    func fetchProfile(code: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        guard let request = makeProfileRequest(code: code) else {
            completion(.failure(NSError(domain: "ProfileService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Запрос не сформирован"])))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
          
            switch result {
            case .success(let data):
                    let profileModel = ProfileModel(from: data)
                    self.updateProfileDetails(newProfile: profileModel)
                    completion(.success(data))

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
