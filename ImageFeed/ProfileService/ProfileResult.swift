//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 24.02.2025.
//
import UIKit

struct ProfileResult: Decodable {
    let firstName: String
    let lastName: String
    let userName: String
    let bio: String
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case userName = "username"
        case bio = "bio"
    }
}
