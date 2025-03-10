//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 8.02.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {

    func saveBearerToken(token: String) {
        let isSucces = KeychainWrapper.standard.set(
            token, forKey: "BearerToken")
        guard isSucces else {
            print("Ошибка")
            return
        }
    }
    func getBearerToken() -> String? {
        let token: String? = KeychainWrapper.standard.string(
            forKey: "BearerToken")
        return token
    }

    func removeBearerToken() {
        let _: Bool = KeychainWrapper.standard.removeObject(
            forKey: "BearerToken")
    }

    //    private let tokenKey = "BearerToken"
    //    var token: String? {
    //        get {
    //            return UserDefaults.standard.string(forKey: tokenKey)
    //        }
    //        set {
    //            UserDefaults.standard.set(newValue, forKey: tokenKey)
    //        }
    //    }
}
