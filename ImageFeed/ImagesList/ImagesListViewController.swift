//
//  ViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 05.08.2024.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated()
    func tapLikeButton(for cell: ImagesListCell)
    func showHUD()
    func hideHUD()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol, ImageListCellDelegate {
    
    @IBOutlet private var tableView: UITableView!
    var presenter: ImagesListPresenterProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    private(set) var myImageHeight: CGFloat?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "ImagesListViewController"
        presenter?.callFetchPhotos()
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
            let urlLargePhoto = presenter?.photos[indexPath.row].largeImageURL ?? ""
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter else { return }
        if indexPath.row == presenter.photos.count - 1 {
            presenter.callFetchPhotos()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let imageListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            debugPrint("Failed cell typecast to ImagesListCell; table cells are empty")
            return UITableViewCell()
        }
        
        guard
            let thumbImageURL = presenter?.photos[indexPath.row].thumbImageURL,
            let url = URL(string: thumbImageURL)
        else {
            debugPrint("No url for image in thumbImageImageURL \(String(describing: presenter?.photos[indexPath.row].thumbImageURL))")
            return UITableViewCell()
        }
        
        imageListCell.imageCellView.kf.indicatorType = .activity
        imageListCell.imageCellView.kf.setImage(with: url, placeholder: UIImage.scribble) { [weak self] _ in
            guard let self else {return}
            guard let isLiked = presenter?.photos[indexPath.row].isLiked else { return }
            imageListCell.delegate = self
            let createdDate = presenter?.photos[indexPath.row].createdAt
            guard let myImageHeight else {return}
            imageListCell.configCell(cellHeight: myImageHeight, url: url, indexPath: indexPath, isLiked: isLiked, createdAt: createdDate)
        }
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let heightImage = presenter?.photos[indexPath.row].size?.height,
              let widthImage = presenter?.photos[indexPath.row].size?.width
        else {return 0}
        let tableImageSize = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageCellWidth = tableView.bounds.width - tableImageSize.left - tableImageSize.right
        let actualWidth = imageCellWidth / widthImage
        let imageCellHeight = (heightImage * actualWidth) + tableImageSize.top + tableImageSize.bottom
        myImageHeight = imageCellHeight
        return imageCellHeight
    }
//}

//extension ImagesListViewController: ImageListCellDelegate {

    func tapLikeButton(for cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            debugPrint("No indexPath in updateLikeButton -> ImagesListViewController")
            return
        }
        presenter?.updateLikeButton(indexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showHUD() {
        UIBlockingProgressHUD.show()
    }

    func hideHUD() {
        UIBlockingProgressHUD.dismiss()
    }
    
}

