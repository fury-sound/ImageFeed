//
//  ViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 05.08.2024.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    var imageListCellVC = ImagesListCell()
//    private let photosName : [String] = Array(0..<20).map{"\($0)"}
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    var photos: [Photo] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
       
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else {
                debugPrint("no self in viewDidLoad -> ImagesListViewController")
                return }
            self.updateTableViewAnimated()
        }
        
        callFetchPhotos()
//        tableView.reloadData()
//        updateTableViewAnimated()
    }
    
    
    func updateTableViewAnimated() {
        print("in updatePhotos -> ImagesListViewController")
//        let oldCount = photos.count
//        let newCount = imagesListService.photos.count
//        photos = imagesListService.photos
//        if oldCount != newCount {
//            tableView.performBatchUpdates {
//                let indexPaths = (oldCount..<newCount).map { i in
//                    IndexPath(row: i, section: 0)
//                }
//                tableView.insertRows(at: indexPaths, with: .automatic)
//            } completion: { _ in }
//        }
        photos += imagesListService.photos
        tableView.reloadData()
//        print(imagesListService.photos.description)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid seque destination")
                return
            }
//            guard
//                let largeImageImageURL = photos[indexPath.row].largeImageURL,
//                let url = URL(string: largeImageImageURL)
//            else {
//                debugPrint("No url for image in thumbImageImageURL \(String(describing: photos[indexPath.row].largeImageURL))")
//                return
//            }
//            viewController.imageView?.kf.indicatorType = .activity
//            viewController.imageView?.kf.setImage(with: url, placeholder: UIImage.scribble) { _ in
//            }
            
//            let image = UIImage(named: photosName[indexPath.row])
//            viewController.image = image
            viewController.image = UIImage()
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {

    func callFetchPhotos() {
        imagesListService.fetchPhotosNextPage() { handler in
            switch handler {
            case .success(let photos):
                print("success in imagesListService.fetchPhotosNextPage call -> tableView -> ImagesListViewController")
                self.photos += photos
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                debugPrint("fatch error in imagesListService.fetchPhotosNextPage call -> tableView -> ImagesListViewController: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("in tableView - row \(indexPath.row)")

        if indexPath.row == photos.count - 1 {
            callFetchPhotos()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        guard let imageListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            debugPrint("Failed cell typecast to ImagesListCell; table cells are empty")
            return UITableViewCell()
        }
        
        guard
            let thumbImageImageURL = photos[indexPath.row].thumbImageURL,
            let url = URL(string: thumbImageImageURL)
        else {
            debugPrint("No url for image in thumbImageImageURL \(String(describing: photos[indexPath.row].thumbImageURL))")
            return UITableViewCell()
        }
        
//        imageListCell.imageView?.kf.indicatorType = .activity
//        imageListCell.imageView?.kf.setImage(with: url, placeholder: UIImage.scribble)
//        { [weak self] _ in
//            guard let self else {return}
            let actualRowHeight = self.tableView.rowHeight
//            let image = imageListCell.imageView?.image
//            self.imageListCellVC.configCell(in: tableView, for: imageListCell, with: indexPath)
//            self.tableView.rowHeight = self.imageListCellVC.configCell(rowHeight: actualRowHeight, cell: imageListCell)
            tableView.rowHeight = self.imageListCellVC.configCell(rowHeight: actualRowHeight, cell: imageListCell, url: url)
//        }
    
        tableView.reloadRows(at: [indexPath], with: .automatic)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
}

