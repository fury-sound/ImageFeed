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
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "ActiveProfile"),
            selectedImage: nil)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
