//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 15.08.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var arrowButton: UIButton!
//    @IBOutlet weak var labelName: UILabel!
//    @IBOutlet weak var labelTG: UILabel!
//    @IBOutlet weak var labelPhrase: UILabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        arrowButton.titleLabel?.text = ""
//        imageSetup()
//    }
//    
//    func imageSetup() {
//        
//    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 26/255.0, green: 27/255.0, blue: 34/255.0, alpha: 1)
        imageSetup()
    }
    
    private func imageSetup() {
        
        let profileImage = UIImage(named: "Ekat_nov")
        let imageView = UIImageView(image: profileImage)
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75).isActive = true
        
        let arrowButton = UIButton()
        let buttonImage = UIImage(named: "Exit")
        arrowButton.setImage(buttonImage, for: .normal)
        view.addSubview(arrowButton)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        arrowButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let labelName = UILabel()
        labelName.text = "Екатерина Новикова"
        labelName.font = UIFont(name: "SFPro-Bold", size: 23)
        labelName.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(labelName)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        let labelTG = UILabel()
        labelTG.text = "@ekaterina_nov"
        labelTG.font = UIFont(name: "SF Pro", size: 13)
        labelTG.textColor = UIColor(red: 174/255.0, green: 175/255.0, blue: 180/255.0, alpha: 1.0)
        
        view.addSubview(labelTG)
        labelTG.translatesAutoresizingMaskIntoConstraints = false
        labelTG.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        labelTG.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8).isActive = true

        let labelPhrase = UILabel()
        labelPhrase.text = "Hello, world!"
        labelPhrase.font = UIFont(name: "SF Pro", size: 13)
        labelPhrase.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(labelPhrase)
        labelPhrase.translatesAutoresizingMaskIntoConstraints = false
        labelPhrase.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        labelPhrase.topAnchor.constraint(equalTo: labelTG.bottomAnchor, constant: 8).isActive = true
        
    }
    
}
