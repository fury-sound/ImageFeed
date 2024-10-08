//
//  ViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 05.08.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    var imageListCellVC = ImagesListCell()
    private let photosName : [String] = Array(0..<20).map{"\($0)"}
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private let oauth2TokenStorage = OAuth2TokenStorage()

    
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
            self.updatePhotos()
        }
    }
    
    
    func updatePhotos() {
        print("in updatePhotos -> ImagesListViewController")
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
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
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
        print("1. in tableView")
//        print(indexPath.row, imagesListService.photos.count)
//        print(indexPath.row == imagesListService.photos.count)
//        if indexPath.row + 1 == imagesListService.photos.count {
            print("2. in if in tableView")

            guard let token = oauth2TokenStorage.token else {return}
            imagesListService.fetchPhotosNextPage(token) { handler in
                switch handler {
                case .success:
                    print("success in imagesListService.fetchPhotosNextPage call -> tableView -> ImagesListViewController")
                case .failure(let error):
                    debugPrint("fatch error in imagesListService.fetchPhotosNextPage call -> tableView -> ImagesListViewController: \(error.localizedDescription)")
                    return
                }
            }
//        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let imageListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            debugPrint("Failed cell typecast to ImagesListCell; table cells are empty")
            return UITableViewCell()
        }
        
        imageListCellVC.configCell(in: tableView, for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
}

