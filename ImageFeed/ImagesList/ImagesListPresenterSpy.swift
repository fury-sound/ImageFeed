//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 27.10.2024.
//

import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var inCallFetchPhotos: Bool = false
    
    var photos: [Photo] = []
    
    func callFetchPhotos() {
        inCallFetchPhotos = true
    }
    
    func updateLikeButton(indexPath: IndexPath, currentCell: ImagesListCell) {
        
    }
    
    func view(_ view: any ImagesListViewControllerProtocol) {
        
    }
    
    
}
