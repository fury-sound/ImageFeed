//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 28.09.2024.
//

import UIKit

final class TabBarController: UITabBarController {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenter()
        imagesListViewController.presenter = presenter
        presenter.view(imagesListViewController)
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "ImagesList"),
            selectedImage: nil)
        imagesListViewController.tabBarItem.accessibilityIdentifier = "Images List"
        let presenterProfile = ProfileViewPresenter()
        let profileViewController = ProfileViewController(presenter: presenterProfile)
        profileViewController.tabBarItem.accessibilityIdentifier = "Profile"
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "ActiveProfile"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
