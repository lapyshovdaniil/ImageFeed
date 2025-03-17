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
        let full: String
        
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

struct PhotoResponse: Decodable {
    let photo: Photo

    struct Photo: Decodable {
        let id: String
        let likedByUser: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case likedByUser = "liked_by_user"
        }
    }
}

extension PhotoResult {
    private static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    var asPhoto: Photo {
        return Photo(
            id: self.id,
            size: CGSize(width: self.width, height: self.height),
            createdAt: PhotoResult.dateFormatter.date(from: self.createdAt),
            welcomeDescription: self.description,
            thumbImageURL: self.urls.thumb,
            largeImageURL: self.urls.regular,
            fullImageUrl: self.urls.full,
            isLiked: self.likedByUser
        )
    }
}
