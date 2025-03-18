//
//  Constants.swift
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

