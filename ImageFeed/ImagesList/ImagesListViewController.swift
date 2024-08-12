//
//  ViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 05.08.2024.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    private let photosName : [String] = Array(0..<20).map{"\($0)"}
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        //        tableView.isUserInteractionEnabled = true
        //        tableView.isScrollEnabled = true
        //        tableView.reloadData()
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        //        cell.backgroundColor = .clear
        /// using UIBlurEffect - works fine
        //        cell.imageCellView.backgroundColor = .clear
        //        let blurEffect = UIBlurEffect(style: .regular)
        //        let blurView = UIVisualEffectView(effect: blurEffect)
        //        blurView.translatesAutoresizingMaskIntoConstraints = false
        //        cell.imageCellView.insertSubview(blurView, at: 0)
        //        NSLayoutConstraint.activate([
        //            blurView.topAnchor.constraint(equalTo: cell.imageCellView.topAnchor),
        //            blurView.leadingAnchor.constraint(equalTo: cell.imageCellView.leadingAnchor),
        //            blurView.heightAnchor.constraint(equalTo: cell.imageCellView.heightAnchor),
        //            blurView.widthAnchor.constraint(equalTo: cell.imageCellView.widthAnchor)
        //        ])
        /// using CAGradientLayer
        //        let gradient = CAGradientLayer()
        ////        let blue = UIColor(red: 10/255, green: 91/255, blue: 133/255, alpha: 0.0)
        ////        let green = UIColor(red: 0, green: 146/255, blue: 139/255, alpha: 0.2)
        //        let start = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.0)
        //        let end = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2)
        ////        gradient.colors = [start.cgColor, end.cgColor, end.cgColor]
        //        gradient.colors = [start.cgColor, end.cgColor]
        //        gradient.locations = [0, 0.2]
        //        gradient.frame = CGRect(x: 0, y: 150, width: cell.imageCellView.frame.size.width, height: cell.imageCellView.frame.size.height)
        //        cell.imageCellView.layer.addSublayer(gradient)
        
        let imageHeartFilled = UIImage(named: "Active")
        let imageHeartEmpty = UIImage(named: "No Active")
        var actualImageHeight: CGFloat = 0.0
        
        //        высота ячейки задается через tableView.rowHeight, а не через метод делегата heightForRowAt
        let rowNumber = indexPath.row
        let imageName = "\(rowNumber)"
        if let currentImage = UIImage(named: imageName) {
            cell.imageCellView.image = currentImage
            //            print(currentImage.size, cell.imageCellView.frame.size)
            //            print(currentImage.size.height/currentImage.size.width)
            let heightImage = currentImage.size.height
            let widthImage = currentImage.size.width
            let widthView = cell.imageCellView.frame.size.width
            //            print("\((heightImage * widthView) / widthImage)")
            actualImageHeight = (heightImage * widthView) / widthImage
            tableView.rowHeight = actualImageHeight
        } else {
            debugPrint("No such image \(indexPath.row) exists")
            return
        }
        
        // создание и настройка фрейма градиента: цвета, расположение, добавление подслоем
        let gradient = CAGradientLayer()
        let start = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.0)
        let end = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2)
        gradient.colors = [start.cgColor, end.cgColor]
        gradient.locations = [0, 0.3]
        
        let y_point = tableView.rowHeight - 8
        //        print(y_point)
        //        let gradientHeight = y_point - cell.imageCellView.frame.size.height
        //        let gradientHeight = cell.dateCellView.frame.size.height + 10
        let gradientHeight: CGFloat = 30.0 // значение высоты фрейма градиента в Figma
        gradient.frame = CGRect(x: 0, y: y_point, width: cell.imageCellView.bounds.size.width, height: -(gradientHeight))
        //        print(y_point, y_point - cell.frame.size.height)
        //        print(cell.dateCellView.frame.minY, cell.dateCellView.frame.maxY)
        //        print(cell.imageCellView.frame.minY, cell.imageCellView.frame.maxY)
        //        if cell.imageCellView.layer.sublayers?.contains(gradient) == nil {
        //            gradient.removeFromSuperlayer()
        cell.imageCellView.layer.addSublayer(gradient)
        
        //размещение строки с текущей датой
        let curDate: Date
        if #available(iOS 15.0, *) {
            curDate = Date.now
        } else {
            curDate = Date()
        }
        cell.dateCellView.text = "\(dateFormatter.string(from: curDate))"
        // размещение изображений для кнопки - нечет белые, чет красные
        if rowNumber % 2 == 0 {
            cell.buttonCellView.setImage(imageHeartEmpty, for: .normal)
        } else {
            cell.buttonCellView.setImage(imageHeartFilled, for: .normal)
        }
        
        
        //        let currentImage = UIImage(named: ("2.jpg")) //?? UIImage()
        //        if currentImage == nil {
        //            print("nil image")
        //        }
        ////        let currentImageView = UIImageView(image: currentImage)
        ////        cell.imageCellView.addSubview(currentImageView)
        //        cell.dateCellView.text = "22 августа 2022 г"
        //        let imageHeartEmpty = UIImage(named: "No Active")
        //        cell.buttonCellView.setBackgroundImage(imageHeartEmpty, for: .normal)
        //        let mySub = UIImageView(image: currentImage)
        //        cell.imageCellView.addSubview(mySub)
        //
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let currentImageName = "\(indexPath.row)"
    //        let currentImage = UIImage(named: currentImageName)
    //        let imageHeight = currentImage?.size.height
    //        print(imageHeight)
    //
    //        return imageHeight!
    //    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //
    //    }
    //
    
    
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesListCell", for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            print("Failed cell typecast to ImagesListCell; table cells are empty")
            return UITableViewCell()
        }
        //        for layer in imageListCell.layer.sublayers {
        //            print(layer.description)
        ////            imageListCell.layer.removeFromSuperlayer()
        //        }
        //        guard let imageListCellImageView = imageListCell.imageCellView else { return UITableViewCell() }
        //        imageListCell.imageCellView.backgroundColor = .clear
        
        //        let currentImage = UIImage(named: "4.jpg")
        //        let currentImage = UIImage(named: "Active")
        //        let currentCellView = UIImageView(image: currentImage)
        //        print(imageListCell.imageCellView.description)
        //        imageListCell.imageCellView.image = currentImage
        configCell(for: imageListCell, with: indexPath)
        //        imageListCell.dateCellView.text = "Hello"
        //        let imageHeartFilled = UIImage(named: "Active")
        //        let imageHeartEmpty = UIImage(named: "No Active")
        //        imageListCell.buttonCellView.setImage(imageHeartEmpty, for: .normal)
        return imageListCell
        
        //        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        print(photosName.count)
        return photosName.count
    }
}

