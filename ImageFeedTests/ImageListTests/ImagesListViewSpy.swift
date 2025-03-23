//
//  ImagesListViewSpy.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 22.03.2025.
//
import Foundation
@testable import ImageFeed

class ImagesListViewSpy: ImageListView {
    var updateTableViewCalled = false
    var updateLikeCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showErrorCalled = false

    func updateTableView() {
        updateTableViewCalled = true
    }
    
    func updateLike(at index: Int, isLiked: Bool) {
        updateLikeCalled = true
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func showError(_ error: Error) {
        showErrorCalled = true
    }
}
