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
    let urls: UrlsResult
    let likedByUser: Bool

    struct UrlsResult: Decodable {
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
        Photo(
            id: self.id,
            size: CGSize(width: width, height: height),
            createdAt: PhotoResult.dateFormatter.date(from: createdAt),
            welcomeDescription: description,
            thumbImageURL: urls.thumb,
            largeImageURL: urls.regular,
            fullImageUrl: urls.full,
            isLiked: likedByUser
        )
    }
}
