//
//  ProfilePresenterTests.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 22.03.2025.
//

import XCTest
@testable import ImageFeed

final class ProfilePresenterTests: XCTestCase {
    
    func testUpdateProfile(){
        //given
        let view = ProfileViewSpy()
        let presenter = ProfilePresenter(view: view)
        
        let profileResult = ProfileResult(firstName: "YP", lastName: "Daniil", userName: "loginName", bio: "description")
        
        //when
        ProfileService.shared.profile = ProfileModel(from: profileResult)
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(view.updateProfileCalled)
    }
    
    func testUpdateAvatar(){
        //given
        let view = ProfileViewSpy()
        let presenter = ProfilePresenter(view: view)
        
        //when
        ProfileImageService.shared.avatarURL = "https://example.com/photo.jpg"
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(view.updateAvatarCalled)
    }
    
    func testexitButtonTapped(){
        //given
        let view = ProfileViewSpy()
        let presenter = ProfilePresenter(view: view)
        
        //when
        presenter.exitButtonTapped()
        
        //then
        XCTAssertTrue(view.showLogoutAlertCalled)
    }
}
