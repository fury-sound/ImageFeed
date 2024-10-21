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
//    var imagesListCell = ImagesListCell()
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private let oauth2TokenStorage = OAuth2TokenStorage()
//    weak var delegate : ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imagesListCell.delegate = self
        callFetchPhotos()
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
    }

    
    
    func updateTableViewAnimated() {
//        print("in updatePhotos -> ImagesListViewController")
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            let urlLargePhoto = photos[indexPath.row].largeImageURL ?? ""
            viewController.urlLargePhoto = URL(string: urlLargePhoto)
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
                DispatchQueue.main.async {
                    self.photos += photos
                }
            case .failure(let error):
                debugPrint("fatch error in imagesListService.fetchPhotosNextPage call -> tableView -> ImagesListViewController: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        print("in tableView - row \(indexPath.row)")
//        print("4. photos count in willDisplay \(indexPath.row) \(photos.count)")
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
            let thumbImageURL = photos[indexPath.row].thumbImageURL,
            let url = URL(string: thumbImageURL)
        else {
            debugPrint("No url for image in thumbImageImageURL \(String(describing: photos[indexPath.row].thumbImageURL))")
            return UITableViewCell()
        }
        
//        imageListCell.imageCellView.kf.indicatorType = .activity
        imageListCell.imageCellView.kf.setImage(with: url, placeholder: UIImage.scribble) { [weak self] _ in
            guard let self else {return}
            let actualRowHeight = self.tableView.rowHeight
            guard let isLiked = photos[indexPath.row].isLiked else { return }
            imageListCell.delegate = self
            imageListCell.configCell(rowHeight: actualRowHeight, url: url, indexPath: indexPath, isLiked: isLiked)
        }

//        tableView.reloadRows(at: [indexPath], with: .automatic)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("3. photos count in heightForRowAt \(photos.count) \(indexPath.row)")
        
        guard let heightImage = photos[indexPath.row].size?.height,
              let widthImage = photos[indexPath.row].size?.width
        else {return 0}
        let tableImageSize = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageCellWidth = tableView.bounds.width - tableImageSize.left - tableImageSize.right
        let actualWidth = imageCellWidth / widthImage
        let imageCellHeight = (heightImage * actualWidth) + tableImageSize.top + tableImageSize.bottom
        return imageCellHeight
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func updateLikeButton(in currentCell: ImagesListCell) {
        print("in updateLikeButton")
        guard let indexPath = tableView.indexPath(for: currentCell) else {
            print("No indexPath")
            return
        }
        print("before toggle: \(String(describing: photos[indexPath.row].id)), isLiked \(String(describing: photos[indexPath.row].isLiked))")
        photos[indexPath.row].isLiked?.toggle()
        let photoId = photos[indexPath.row].id
        let imageLike = photos[indexPath.row].isLiked
        print("after toggle: \(String(describing: photos[indexPath.row].id)), isLiked \(String(describing: photos[indexPath.row].isLiked))")
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photoId, isLike: imageLike) { [weak self] result in
            guard let self else {
                print("no self")
                return
            }
            DispatchQueue.main.async {
                print("in DispatchQueue: \(String(describing: self.photos[indexPath.row].id)), isLiked \(String(describing: self.photos[indexPath.row].isLiked))")
                switch result {
                case .success(let newLikeInfo):
                    print("isLike \(String(describing: self.photos[indexPath.row].isLiked))")
                    self.photos[indexPath.row].isLiked = newLikeInfo
                case .failure(let error):
                    print("Cannot get Like info \(error.localizedDescription)")
                    self.photos[indexPath.row].isLiked?.toggle()
                }
//                self.updateTableViewAnimated()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

