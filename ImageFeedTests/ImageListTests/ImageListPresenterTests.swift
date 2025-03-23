//
//  ImageListTests.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 22.03.2025.
import XCTest
@testable import ImageFeed

class ImageListPresenterTests: XCTestCase {
    
    var viewSpy: ImagesListViewSpy!
    var serviceStub: ImagesListServiceStub!
    var presenter: ImageListPresenter!
    
    override func setUp() {
        super.setUp()
        viewSpy = ImagesListViewSpy()
        serviceStub = ImagesListServiceStub()
        presenter = ImageListPresenter(view: viewSpy, imagesListService: serviceStub)
    }
    
    override func tearDown() {
        viewSpy = nil
        serviceStub = nil
        presenter = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(serviceStub.fetchNextPageCalled)
        XCTAssertTrue(viewSpy.updateTableViewCalled)
    }
    
    func testDidTapLikeSuccess() {
        let expectation = self.expectation(description: "Like operation completes")
        
        serviceStub.shouldFailOnChangeLike = false
        presenter.didTapLike(at: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewSpy.hideLoadingCalled)
            XCTAssertTrue(self.viewSpy.updateLikeCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testDidTapLikeFailure() {
        let expectation = self.expectation(description: "Error on like operation")
        
        serviceStub.shouldFailOnChangeLike = true
        presenter.didTapLike(at: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewSpy.hideLoadingCalled)
            XCTAssertTrue(self.viewSpy.showErrorCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}

