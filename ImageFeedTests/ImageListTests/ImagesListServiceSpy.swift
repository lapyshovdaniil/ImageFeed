//
//  ImageListPresenterSpy.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 22.03.2025.
//
import Foundation
@testable import ImageFeed

class ImagesListServiceStub: ImagesListServiceProtocol {
    var fetchNextPageCalled = false
    var changeLikeCalled = false
    var shouldFailOnChangeLike = false
    
    var photos: [Photo] = [
        Photo(
            id: "01",
            size: CGSize(width: 123, height: 123),
            createdAt: DateFormatter().date(from: "2025-01-22"),
            welcomeDescription: nil,
            thumbImageURL: "https://213.com/pic1.jpg",
            largeImageURL: "https://213.com/pic2.jpg",
            fullImageUrl: "https://213.com/pic3.jpg",
            isLiked: true
        ),
        Photo(
            id: "02",
            size: CGSize(width: 312, height: 312),
            createdAt: DateFormatter().date(from: "1989-08-13"),
            welcomeDescription: "text",
            thumbImageURL: "https://bestwebsite.com/pic1.jpg",
            largeImageURL: "https://bestwebsite.com/pic2.jpg",
            fullImageUrl: "https://bestwebsite.com/pic3.jpg",
            isLiked: false
        )
    ]
    
    func fetchPhotosNextPage() {
        fetchNextPageCalled = true
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
        if shouldFailOnChangeLike {
            completion(.failure(NSError(domain: "Test", code: 0)))
        } else {
            completion(.success(()))
        }
    }
}
