//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Valery Zvonarev on 27.10.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
//    func testViewControllerCallsViewDidLoad() {
//        //given
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
//        let presenter = WebViewPresenterSpy()
//        viewController.presenter = presenter
//        presenter.view = viewController
//        
//        //when
//        _ = viewController.view
//        
//        //then
//        XCTAssertTrue(presenter.viewDidLoadCalled) //behavior verification
//    }
    
    func testAvatarURL() {
        //given
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        viewController.viewDidLoad()
        //when
        let _ = presenter.avatarURL()
        //then
        XCTAssertTrue(presenter.calledAvatarURL)
    }
    
    func testLogoutAction() {
        //given
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        viewController.viewDidLoad()
        //when
        presenter.logoutAction()
        //then
        XCTAssertTrue(presenter.calledLogout)
    }

    func testTokenNil() {
        //given
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewController(presenter: presenter)
        viewController.viewDidLoad()
        //when
        presenter.logoutAction()
        //then
        XCTAssertEqual(OAuth2TokenStorage().token, nil)
    }
    
    
    


}
