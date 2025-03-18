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
        let task = URLSession.shared.data(for: request) { result in
          
            switch result {
            case .success(let data):
                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try JSONDecoder().decode(ProfileResult.self, from: data)
                    completion(.success(response))
                    let profileModel = ProfileModel(from: response)
                    self.updateProfileDetails(newProfile: profileModel)
                    
                } catch {
                    completion(.failure(NSError(domain: "ProfileService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Ошибка JSON"])))
                    
                }
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
