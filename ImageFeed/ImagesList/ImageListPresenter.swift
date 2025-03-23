//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 22.03.2025.
//
import UIKit
import Kingfisher

protocol ImageListView: AnyObject {
    func updateTableView()
    func updateLike(at index: Int, isLiked: Bool)
    func showLoading()
    func hideLoading()
    func showError(_ error: Error)
}

final class ImageListPresenter {
    private weak var view: ImageListView?
    private let imagesListService: ImagesListServiceProtocol
    private var observer: NSObjectProtocol?
    
    var photos: [Photo] {
        imagesListService.photos
    }
    
    init(view: ImageListView, imagesListService: ImagesListServiceProtocol) {
        self.view = view
        self.imagesListService = imagesListService
        
        observer = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification, object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.view?.updateTableView()
        }
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func willDisplayCell(at index: Int) {
        if index == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func didTapLike(at index: Int) {
        guard index < photos.count else { return }
        let photo = photos[index]
        let newLikeState = !photo.isLiked
        
        view?.showLoading()
        imagesListService.changeLike(photoId: photo.id, isLike: newLikeState) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success:
                    self?.view?.updateLike(at: index, isLiked: newLikeState)
                case .failure(let error):
                    self?.view?.showError(error)
                }
            }
        }
    }
}







