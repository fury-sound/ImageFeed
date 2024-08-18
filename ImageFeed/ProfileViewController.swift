//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 15.08.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTG: UILabel!
    @IBOutlet weak var labelPhrase: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrowButton.titleLabel?.text = ""
    }
    
}
