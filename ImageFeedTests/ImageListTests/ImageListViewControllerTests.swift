//
//  ImageListViewControllerTests.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 22.03.2025.
//
import XCTest
@testable import ImageFeed

class ImageListViewControllerTests: XCTestCase {
    
    var viewSpy: ImagesListViewSpy!
    var serviceStub: ImagesListServiceStub!
    var presenter: ImageListPresenter!
    var controller: ImageListViewController!
    
    override func setUp() {
        super.setUp()
        viewSpy = ImagesListViewSpy()
        serviceStub = ImagesListServiceStub()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "ImageListViewController") as? ImageListViewController
        XCTAssertNotNil(controller, "ImageListViewController не найден в Storyboard")
        controller.loadViewIfNeeded()
        presenter = ImageListPresenter(view: viewSpy, imagesListService: serviceStub)
        controller.presenter = presenter
    }
    
    override func tearDown() {
        viewSpy = nil
        serviceStub = nil
        presenter = nil
        controller = nil
        super.tearDown()
    }
    
    func testTableViewUpdatesOnViewDidLoad() {
        controller.loadViewIfNeeded() // Загружаем view перед вызовом viewDidLoad()
        controller.viewDidLoad()
        XCTAssertTrue(viewSpy.updateTableViewCalled)
    }
    
    func testShowAndHideLoading() {
        presenter.didTapLike(at: 0)
        
        XCTAssertTrue(viewSpy.showLoadingCalled)
        
        serviceStub.shouldFailOnChangeLike = false
        presenter.didTapLike(at: 0)
        
        let expectation = self.expectation(description: "Like operation completes")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewSpy.hideLoadingCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
