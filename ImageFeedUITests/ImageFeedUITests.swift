//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Valery Zvonarev on 28.10.2024.
//

import XCTest

class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения теста
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    private func authEnter() {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["WebViewViewController"]
//        print(app.debugDescription)
//        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        sleep(10)
        let loginTextField = webView.descendants(matching: .textField).element
//        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        sleep(10)
        loginTextField.tap()
        loginTextField.typeText("")
        sleep(5)
        XCUIApplication().toolbars.buttons["Done"].tap()
        webView.swipeUp()
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        passwordTextField.tap()
        passwordTextField.typeText("")
        sleep(5)
        XCUIApplication().toolbars.buttons["Done"].tap()
        webView.swipeUp()
        webView.buttons["Login"].tap()
    }
    
    //тестируем сценарий авторизации
    func testAuth() throws {
        if app.buttons["Authenticate"].exists {
            authEnter()
        }
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    // тестируем сценарий ленты
    func testFeed() throws {
        if app.buttons["Authenticate"].exists {
            authEnter()
        }
        let tablesQuery = app.tables
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
        sleep(10)
        cell.swipeUp()
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
//        sleep(5)
        let cellWithLike = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        sleep(10)
        cellWithLike.buttons["LikeButton"].tap()
        sleep(10)
        cellWithLike.buttons["LikeButton"].tap()
        sleep(10)
        cellWithLike.tap()
        sleep(10)
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        let navigateBackButton = app.buttons["NavigationBackButton"]
        navigateBackButton.tap()
    }
    
    // тестируем сценарий профиля
    func testProfile() {
        if app.buttons["Authenticate"].exists {
            authEnter()
        }
        sleep(10)
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        app.buttons["LogoutButton"].tap()
        app.alerts["Byebye!"].scrollViews.otherElements.buttons["Yes"].tap()
        sleep(10)
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
