//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 15.08.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    var delegate = SplashViewController()
    private var oauth2TokenStorage = OAuth2TokenStorage()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 26/255.0, green: 27/255.0, blue: 34/255.0, alpha: 1)
        profileSetup()
    }
    
    private func profileSetup() {
        
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
        arrowButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside) // logout action
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
    
    // temporary function to clean all UserDefaults values
    private func cleanUserDefaults() {
        let allValues = UserDefaults.standard.dictionaryRepresentation()
        allValues.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
//        let keyValue = "bearerToken"
//        print("value \(UserDefaults.standard.string(forKey: keyValue))")
    }
    
    // logout button function
    @objc private func logoutAction() {
        oauth2TokenStorage.token = ""
//        cleanUserDefaults()
        self.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid windows configuration")
            return
        }
        let splashViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "SplashViewVC")
        splashViewController.modalTransitionStyle = .crossDissolve
        splashViewController.modalPresentationStyle = .fullScreen
        window.rootViewController = splashViewController
    }
    
}
