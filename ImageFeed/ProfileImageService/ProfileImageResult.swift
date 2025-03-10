//
//  ProfileImageResult.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 1.03.2025.
//
import Foundation

struct ProfileImageResult: Decodable {
    struct ProfileImage: Decodable {
        let large: String

        enum CodingKeys: String, CodingKey {
            case large
        }
    }

    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
