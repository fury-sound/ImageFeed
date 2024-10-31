//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Valery Zvonarev on 27.10.2024.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behavior verification
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authHelper = AuthHelper()
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadRequestCalled) //behavior verification
    }
    
    func testProgressVisibleLessThanOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress) //behavior verification
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress) // return value verification
        
        //then
        XCTAssertTrue(shouldHideProgress) //behavior verification
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper()
        guard var urlComponents = URLComponents(
            string: "https://unsplash.com/oauth/authorize/native")
        else {
            debugPrint("Error creating urlComponents from URLComponents")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: "test code")
        ]
        guard let url = urlComponents.url else {
            debugPrint("Error of url from urlComponents.url")
            return
        }
        
        //when
        let codeResult = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(codeResult, "test code")
    }
    
}
