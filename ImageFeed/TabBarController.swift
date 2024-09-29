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
        print("in awakeFromNib")
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
//        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
//        imagesListViewController.tabBarItem.image = UIImage(named: "folder.fill")
//        imagesListViewController.tabBarItem.title = "Images"
//        imagesListViewController.tabBarItem = UITabBarItem(
//            title: "Images",
//            image: UIImage(named: "active.png"),
//            selectedImage: nil)
//        imagesListViewController.tabBarItem.badgeColor = .red
//        guard let image = UIImage(named: "ActiveProfile") else {
//            print("no image at \(UIImage(named: "ActiveProfile"))")
//            return
//        }
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "ActiveProfile"),
            selectedImage: nil)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
