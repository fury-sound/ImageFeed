//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Valery Zvonarev on 27.10.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {

    func testlogoutAction() {
        //given
        let presenter = ImagesListPresenterSpy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        presenter.view(viewController)
        viewController.presenter = presenter
        _ = viewController.view

        //when
        presenter.callFetchPhotos()
        
        //then
        XCTAssertTrue(presenter.inCallFetchPhotos)
    }
    
    func testPhotosStructure() {
        //given
        let presenter = ImagesListPresenterSpy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        presenter.view(viewController)
        viewController.presenter = presenter
        _ = viewController.view

        //when
        presenter.photos = [.init(id: "1", size: .init(width: 1, height: 1), createdAt: .init(timeIntervalSince1970: 1), welcomeDescription: "1", thumbImageURL: .init(""), largeImageURL: .init(""))]
//        presenter.photos = [Photo(id: nil, size: nil, createdAt: nil, welcomeDescription: nil, thumbImageURL: nil, largeImageURL: nil, isLiked: nil)]
        
        //then
        XCTAssertFalse(presenter.photos.isEmpty)
    }
    
    func testIsPhotosEmpty() {
        //given
        let presenter = ImagesListPresenterSpy()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        presenter.view(viewController)
        viewController.presenter = presenter
        _ = viewController.view

        //when
        presenter.photos = []
        
        //then
        XCTAssertTrue(presenter.photos.isEmpty)
    }
    
}
