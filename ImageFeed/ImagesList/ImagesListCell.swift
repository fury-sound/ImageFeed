//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 07.08.2024.
//

import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func tapLikeButton(for cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var imageCellView: UIImageView!
    @IBOutlet private weak var dateCellView: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    private let imagesListService = ImagesListService.shared
    weak var delegate: ImageListCellDelegate?
    private let gradient = CAGradientLayer()
        
    @objc private func isLikeChangeFunction() {
        delegate?.tapLikeButton(for: self)
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
//    func setIsLiked(isLiked: Bool) {
//        let likeImage = isLiked ? UIImage.likeOn : UIImage.likeOff
//        self.likeButton.setImage(likeImage, for: .normal)
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCellView.kf.cancelDownloadTask()
    }
    
    
    func gradientSetup(cellHeight: CGFloat) {
        // создание и настройка фрейма градиента: цвета, расположение, добавление подслоем
        let trueHeight = cellHeight - 40
        let trueWidth = self.imageCellView.frame.maxX
        gradient.frame = CGRect(x: 0, y: trueHeight, width: trueWidth, height: 30)
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 0.1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 0.2).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 0.3).cgColor
        ]
        gradient.masksToBounds = true
        imageCellView.layer.addSublayer(gradient)
    }

    func configCell(cellHeight: CGFloat, url: URL, indexPath: IndexPath, isLiked: Bool, createdAt: Date?) {
        
        likeButton.accessibilityIdentifier = "LikeButton"
        
        gradientSetup(cellHeight: cellHeight)
        
        self.selectionStyle = .none
        let likeImage = isLiked ? UIImage.likeOn : UIImage.likeOff
        self.likeButton.setImage(likeImage, for: .normal)
        
        likeButton.addTarget(self,
                                 action: #selector(isLikeChangeFunction),
                                 for: .touchUpInside)
        
        //размещение строки с текущей датой
        let curDate: Date
        var dateToShow: String
        if #available(iOS 15.0, *) {
            curDate = Date.now
        } else {
            curDate = Date()
        }
                
        if let tempDate = createdAt {
            dateToShow = dateFormatter.string(from: tempDate)
        } else {
            dateToShow = dateFormatter.string(from: curDate)
        }
        self.dateCellView.text = dateToShow
    }
}
