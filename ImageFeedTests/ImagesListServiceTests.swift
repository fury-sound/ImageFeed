//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Valery Zvonarev on 08.10.2024.
//

@testable import ImageFeed
//import Testing
import XCTest

//struct ImageFeedTests {
//
//    @Test func example() async throws {
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//    }
//
//}

final class ImagesListServiceTests: XCTestCase {
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
//    func testExample() {
//        print("in test testExample() -> ImagesListServiceTests")
//    }
    
    func testFetchPhotos() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                print("in handler")
//                expectation.fulfill()
            }
        
        guard let token = oauth2TokenStorage.token else {return}
        service.fetchPhotosNextPage(token) { handler in
            expectation.fulfill()
            switch handler {
            case .success:
                print("success in imagesListService.fetchPhotosNextPage call -> tableView -> ImagesListViewController")
            case .failure(let error):
                debugPrint("fatch error in imagesListService.fetchPhotosNextPage call -> tableView -> ImagesListViewController: \(error.localizedDescription)")
                return
            }
        }
//        self.wait(for: [expectation], timeout: 10)
        waitForExpectations(timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
    
}
