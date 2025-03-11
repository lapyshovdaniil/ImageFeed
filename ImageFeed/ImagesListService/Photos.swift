//
//  Photos.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 11.03.2025.
//
import Foundation

import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(from photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        
        // Используем DateFormatter для более гибкой обработки дат
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // формат для даты, получаемой с Unsplash
        self.createdAt = dateFormatter.date(from: photoResult.createdAt)
        
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.regular
        self.isLiked = photoResult.likedByUser
    }
}

// Преобразование массива PhotoResult в массив Photo
func transformPhotoResultsToPhotos(photoResults: [PhotoResult]) -> [Photo] {
    return photoResults.map { Photo(from: $0) }
}
