//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 24.01.2025.
//

import Foundation
enum Constants {
    static let accessKey: String = "BNmwsOK6QBGgEIoxr5DYBq2TplOX_V05Zq5XCJJJzS0"
    static let secretKey: String = "1gED7loqYVNtARsGta9rqawL_KAj4P-bW6P1_-bqYC8"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let unsplashAuthorizeURLString: String
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, unsplashAuthorizeURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
    static var standard: AuthConfiguration {
        
        return AuthConfiguration(accessKey: Constants.accessKey, secretKey: Constants.accessScope, redirectURI: Constants.redirectURI, accessScope: Constants.accessScope, defaultBaseURL: Constants.defaultBaseURL!, unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString)
    }
}

