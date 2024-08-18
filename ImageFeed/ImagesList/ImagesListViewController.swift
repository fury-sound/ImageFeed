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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

//extension ImagesListViewController: UITableViewDelegate {
//        // нет методов в моем варианте, высота изображения определяется по rowHeight в configCell, а не в функции делегата heightForRowAt
//}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let imageListCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            print("Failed cell typecast to ImagesListCell; table cells are empty")
            return UITableViewCell()
        }
        
        imageListCellVC.configCell(in: tableView, for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
}

