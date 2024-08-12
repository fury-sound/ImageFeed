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
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let imageHeartFilled = UIImage(named: "Active")
        let imageHeartEmpty = UIImage(named: "No Active")
        var actualImageHeight: CGFloat = 0.0
        
        //        высота ячейки задается через tableView.rowHeight, а не через метод делегата heightForRowAt
        let rowNumber = indexPath.row
        let imageName = "\(rowNumber)"
        if let currentImage = UIImage(named: imageName) {
            cell.imageCellView.image = currentImage
            let heightImage = currentImage.size.height
            let widthImage = currentImage.size.width
            let widthView = cell.imageCellView.frame.size.width
            actualImageHeight = (heightImage * widthView) / widthImage
            tableView.rowHeight = actualImageHeight
        } else {
            debugPrint("No such image \(indexPath.row) exists")
            return
        }
        
        // для градиента использован CAGradientLayer. В теории, можно было бы попробовать UIBlurEffect...
        // но не очень понятно, можно ли в нем задать градиент в соответствии с дизайном
        // создание и настройка фрейма градиента: цвета, расположение, добавление подслоем
        let gradient = CAGradientLayer()
        let start = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.0)
        let end = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2)
        gradient.colors = [start.cgColor, end.cgColor]
        gradient.locations = [0, 0.3]
        let y_point = tableView.rowHeight - 8
        let gradientHeight: CGFloat = 30.0 // значение высоты фрейма градиента в Figma
        gradient.frame = CGRect(x: 0, y: y_point, width: cell.imageCellView.bounds.size.width, height: -(gradientHeight))
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
    }
}

extension ImagesListViewController: UITableViewDelegate {
        // нет методов в моем варианте, высота изображения определяется по rowHeight в configCell, а не в функции делегата heightForRowAt
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            print("Failed cell typecast to ImagesListCell; table cells are empty")
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
}

