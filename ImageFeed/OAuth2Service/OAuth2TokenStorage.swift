//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 8.02.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    enum UserDefaultsKeys {
        static let bearerToken = "BearerToken"
    }

    func saveBearerToken(token: String) {
        let isSucces = KeychainWrapper.standard.set(
            token, forKey: UserDefaultsKeys.bearerToken)
        guard isSucces else {
            print("Ошибка")
            return
        }
    }
    func getBearerToken() -> String? {
        let token: String? = KeychainWrapper.standard.string(
            forKey: UserDefaultsKeys.bearerToken)
        return token
    }

    func removeBearerToken() {
        let _: Bool = KeychainWrapper.standard.removeObject(
            forKey: UserDefaultsKeys.bearerToken)
    }
}
