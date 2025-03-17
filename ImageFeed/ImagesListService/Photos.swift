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
    let fullImageUrl: String
    let isLiked: Bool
}
