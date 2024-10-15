//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 07.08.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet private weak var imageCellView: UIImageView!
    
    @IBOutlet private weak var dateCellView: UILabel!
    
    @IBOutlet private weak var buttonCellView: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    private let imagesListService = ImagesListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    //    override func didMoveToWindow() {
    //        super.didMoveToWindow()
    //
    //    }
    
    //    private func gradientSetup() {}
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // подготовка ячейки перед переиспользованием - удаляю все подслои, иначе фрейм градиента и, видимо, кнопки накладываются
        if self.imageCellView.layer.sublayers?.count != nil  {
            self.imageCellView.layer.sublayers?.removeAll()
        }
        imageCellView.kf.cancelDownloadTask()
    }
    
    func configCell(rowHeight: CGFloat, cell: ImagesListCell, url: URL, indexPath: IndexPath) {
        let imageHeartFilled = UIImage(named: "Active")
        let imageHeartEmpty = UIImage(named: "No Active")
//        var actualImageHeight: CGFloat = 0.0
//        print("Сell \(cell.description)")
        cell.selectionStyle = .none
        
        // высота ячейки задается через tableView.rowHeight, а не через метод делегата heightForRowAt
        //        let rowNumber = indexPath.row
        //        let imageName = "\(rowNumber)"
        //        let imageName = "\(rowNumber)"
//        cell.imageView?.kf.indicatorType = .activity
//        cell.imageView?.kf.setImage(with: url, placeholder: UIImage.scribble)

//        guard let imageCellView = cell.imageCellView else {return 0}
//        if let currentImage = imageCellView.image {
            //            cell.imageCellView.image = currentImage
//            guard let heightImage = imagesListService.photos[indexPath.row].size?.height,
//                  let widthImage = imagesListService.photos[indexPath.row].size?.width
//            else {return 0}
//            let widthView = cell.imageCellView.frame.size.width
//            actualImageHeight = (heightImage * widthView) / (widthImage)
            //            tableView.rowHeight = actualImageHeight
//        } else {
//            debugPrint("No image exists")
//            return 0
//        }

        
        // создание и настройка фрейма градиента: цвета, расположение, добавление подслоем
//        let gradient = CAGradientLayer()
//        let start = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.0)
//        let end = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2)
//        gradient.colors = [start.cgColor, end.cgColor]
//        gradient.locations = [0, 0.3]
//        let y_point = rowHeight - 8
//        let gradientHeight: CGFloat = 30.0 // значение высоты фрейма градиента в Figma
//        gradient.frame = CGRect(x: 0, y: y_point, width: cell.imageCellView.bounds.size.width, height: -(gradientHeight))
//        cell.imageCellView.layer.addSublayer(gradient)
        
        //размещение строки с текущей датой
        let curDate: Date
        if #available(iOS 15.0, *) {
            curDate = Date.now
        } else {
            curDate = Date()
        }
        cell.dateCellView.text = "\(dateFormatter.string(from: curDate))"
        
        // размещение изображений для кнопки - нечет белые, чет красные
        let isHeartFilled = Int(rowHeight) % 2 == 0
        let heartImage = isHeartFilled ? imageHeartFilled : imageHeartEmpty
        cell.buttonCellView.setImage(heartImage, for: .normal)
        
//        return actualImageHeight
    }
}
    
//    func configCell_old(in tableView: UITableView, for cell: ImagesListCell, with indexPath: IndexPath) {
//        let imageHeartFilled = UIImage(named: "Active")
//        let imageHeartEmpty = UIImage(named: "No Active")
//        var actualImageHeight: CGFloat = 0.0
//        cell.selectionStyle = .none
//        
//        // высота ячейки задается через tableView.rowHeight, а не через метод делегата heightForRowAt
//        let rowNumber = indexPath.row
////        let imageName = "\(rowNumber)"
//        let imageName = "\(rowNumber)"
//        
//        if let currentImage = UIImage(named: imageName) {
//            cell.imageCellView.image = currentImage
//            let heightImage = currentImage.size.height
//            let widthImage = currentImage.size.width
//            let widthView = cell.imageCellView.frame.size.width
//            actualImageHeight = (heightImage * widthView) / widthImage
//            tableView.rowHeight = actualImageHeight
//        } else {
//            debugPrint("No such image \(indexPath.row) exists")
//            return
//        }
//        
//        
//        // создание и настройка фрейма градиента: цвета, расположение, добавление подслоем
//        let gradient = CAGradientLayer()
//        let start = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.0)
//        let end = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2)
//        gradient.colors = [start.cgColor, end.cgColor]
//        gradient.locations = [0, 0.3]
//        let y_point = tableView.rowHeight - 8
//        let gradientHeight: CGFloat = 30.0 // значение высоты фрейма градиента в Figma
//        gradient.frame = CGRect(x: 0, y: y_point, width: cell.imageCellView.bounds.size.width, height: -(gradientHeight))
//        cell.imageCellView.layer.addSublayer(gradient)
//        
//        //размещение строки с текущей датой
//        let curDate: Date
//        if #available(iOS 15.0, *) {
//            curDate = Date.now
//        } else {
//            curDate = Date()
//        }
//        cell.dateCellView.text = "\(dateFormatter.string(from: curDate))"
//        
//        // размещение изображений для кнопки - нечет белые, чет красные
//        let isHeartFilled = rowNumber % 2 == 0
//        let heartImage = isHeartFilled ? imageHeartFilled : imageHeartEmpty
//        cell.buttonCellView.setImage(heartImage, for: .normal)
//    }
//}
