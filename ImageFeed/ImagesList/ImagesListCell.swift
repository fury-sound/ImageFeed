//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 07.08.2024.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var imageCellView: UIImageView!
    
    @IBOutlet weak var dateCellView: UILabel!
    
    @IBOutlet weak var buttonCellView: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    
}
