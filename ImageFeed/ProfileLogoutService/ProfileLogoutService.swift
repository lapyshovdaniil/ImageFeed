//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 16.03.2025.
//
import Foundation
import WebKit

final class ProfileLogoutService {
    
   static let shared = ProfileLogoutService()
   private init() {}
    
    private let imageListService = ImagesListService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let OAuthstorage = OAuth2TokenStorage()

   func logout() {
       cleanCookies()
       cleanProfile()
   }

   private func cleanCookies() {
      HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
          
      }
   }
    private func cleanProfile() {
        UserDefaults.standard.removeObject(forKey: "BearerToken")
        OAuthstorage.removeBearerToken()
        imageListService.clear()
        profileImageService.clear()
        profileService.clear()
    }
}
