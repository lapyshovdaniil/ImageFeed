//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 11.03.2025.
//
import UIKit

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: URLs
    let likedByUser: Bool
    struct URLs: Decodable {
        let regular: String
        let thumb: String
    }
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case urls 
        case likedByUser = "liked_by_user"
    }
}
