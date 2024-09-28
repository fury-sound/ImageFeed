//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 15.08.2024.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

final class ProfileViewController: UIViewController {
    
    var delegate = SplashViewController()
    //    private var oauth2TokenStorage = OAuth2TokenStorage()
    private let keyChainStorage = KeyChainStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var profileImage = UIImage(named: "Ekat_nov")
    private var imageView = UIImageView()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        //        updateAvatar()
        //        print("1 ProfileViewController ProfileViewControllerviewDidLoad")
        //        print(profileService.profile, profileService.profileResult)
        view.backgroundColor = UIColor(red: 26/255.0, green: 27/255.0, blue: 34/255.0, alpha: 1)
        profileSetup()
    }
    
    private func updateAvatar() {
        //        print("in updateAvatar \(String(describing: profileImageService.avatarURL))")
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            print("No url for image in profileImageURL \(String(describing: profileImageService.avatarURL))")
            return
        }
        //TODO Обновить аватар с помощью Kingfisher
        //        print("avatarURL in ProfileViewController \(profileImageURL)")
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        imageView.kf.setImage(with: url,
                              options: [
                                .processor(processor)
                              ])
    }
    
    private func profileSetup() {
        
        //        imageView = UIImageView(image: profileImage)
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
        
        //        nameLabel.text = "Екатерина Новикова"
        nameLabel.text = ""
        nameLabel.font = UIFont(name: "SFPro-Bold", size: 23)
        nameLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        
        //        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.text = ""
        loginNameLabel.font = UIFont(name: "SF Pro", size: 13)
        loginNameLabel.textColor = UIColor(red: 174/255.0, green: 175/255.0, blue: 180/255.0, alpha: 1.0)
        
        view.addSubview(loginNameLabel)
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        //        descriptionLabel.text = "Hello, world!"
        descriptionLabel.text = ""
        descriptionLabel.font = UIFont(name: "SF Pro", size: 13)
        descriptionLabel.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        
        guard let profile = profileService.profile else {return}
        updateProfileDetails(profile: profile)
        
        //        guard let token = oauth2TokenStorage.token else { return }
        //        profileService.fetchProfile(token) { result in
        //            switch result {
        //            case .success(let profile):
        //                print("profile")
        //                self.nameLabel.text = profile.name
        //                self.loginNameLabel.text = profile.loginName
        //                if profile.bio != nil {
        //                    self.descriptionLabel.text = profile.bio
        //                } else {
        //                    self.descriptionLabel.text = "Hello, world!"
        //                }
        //            case .failure(let error):
        //                print("Profile fetch error", error)
        //            }
        //        }
        
    }
    
    private func updateProfileDetails(profile: Profile) {
        //        print("2 ProfileViewController updateProfileDetails")
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        if profile.bio != nil {
            descriptionLabel.text = profile.bio
        } else {
            descriptionLabel.text = "Hello, world!"
        }
        updateAvatar()
        
        //        print(profileService.profile)
        //        nameLabel.text = profileService.profile?.name
        //        loginNameLabel.text = profileService.profile?.loginName
        //        if profileService.profile?.bio != nil {
        //            descriptionLabel.text = profileService.profile?.bio
        //        } else {
        //            descriptionLabel.text = "Hello, world!"
        //        }
    }
    
    // temporary function to clean all UserDefaults values
    private func checkIfTokenIsRemoved() {
//        let allValues = UserDefaults.standard.dictionaryRepresentation()
//        allValues.keys.forEach { key in
//            UserDefaults.standard.removeObject(forKey: key)
//        }
        // checking if bearerToken was removed
        let keyValue = "bearerToken"
        let isSuccess: String? = KeychainWrapper.standard.string(forKey: keyValue)
        guard let isSuccess else {
            print("token value is nil")
            return
        }
        print("isSuccess in ProfileViewController \(isSuccess)")
    }
    
    // logout button function
    @objc private func logoutAction() {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "bearerToken")
        //        keyChainStorage.token = nil
        print("Current token: \(String(describing: keyChainStorage.token))")
//        checkIfTokenIsRemoved() // calling temporary function
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
