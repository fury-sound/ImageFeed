//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 27.10.2024.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var photos: [Photo] { get }
    func callFetchPhotos()
    func updateLikeButton(indexPath: IndexPath, currentCell: ImagesListCell)
    func view (_ view: ImagesListViewControllerProtocol)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var delegate: ImagesListViewControllerProtocol?
    private(set) var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared

    func view(_ view: ImagesListViewControllerProtocol) {
        self.delegate = view
    }
    
    func callFetchPhotos() {
        imagesListService.fetchPhotosNextPage() { [weak self] handler in
            guard let self else { return }
            switch handler {
            case .success(let photos):
                DispatchQueue.main.async {
                    self.photos += photos
                    self.delegate?.updateTableViewAnimated()
                }
            case .failure(let error):
                debugPrint("fatch error in imagesListService.fetchPhotosNextPage call -> tableView -> ImagesListViewController: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func updateLikeButton(indexPath: IndexPath, currentCell: ImagesListCell) {
        photos[indexPath.row].isLiked?.toggle()
        let photoId = photos[indexPath.row].id
        let imageLike = photos[indexPath.row].isLiked
        delegate?.showHUD()
        imagesListService.changeLike(photoId: photoId, isLike: imageLike) { [weak self] result in
            guard let self else {
                debugPrint("no self updateLikeButton -> ImagesListViewController")
                return
            }
            DispatchQueue.main.async {
                switch result {
                case .success(let newLikeInfo):
                    self.photos[indexPath.row].isLiked = newLikeInfo
//                    guard let isLikedStatus = self.photos[indexPath.row].isLiked else {return}
//                    currentCell.setIsLiked(isLiked: isLikedStatus)
                case .failure(let error):
                    debugPrint("Cannot get Like info \(error.localizedDescription)")
                    self.photos[indexPath.row].isLiked?.toggle()
                }
                self.delegate?.updateTableViewAnimated()
                self.delegate?.hideHUD()
            }
        }
    }
    
}
