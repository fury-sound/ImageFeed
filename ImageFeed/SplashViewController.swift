//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 06.09.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthVCSegueIdentifier = "toAuthVC"
    private let oauth2TokenStorage = OAuth2TokenStorage()
//    : UserDefaults = .standard

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        var id: String = ""
//        oauth2TokenStorage.token = ""
        if oauth2TokenStorage.token == "" {
            print("no token")
            id = "AuthorizeVC"
        } else {
            print("token present")
            id = "ViewingDataVC"
        }
        showNextVC(for: id)
    }
    
    func showNextVC(for id: String) {
        print("in showNextVC")
        if id == "AuthorizeVC" {
            if let naviViewController = storyboard?.instantiateViewController(withIdentifier: id) as? UINavigationController {
                naviViewController.modalTransitionStyle = .crossDissolve
                naviViewController.modalPresentationStyle = .fullScreen
                present(naviViewController, animated: false, completion: nil)
            }
        } else {
            if let tabBarViewController = storyboard?.instantiateViewController(withIdentifier: id) as?  UITabBarController {
                tabBarViewController.modalTransitionStyle = .crossDissolve
                tabBarViewController.modalPresentationStyle = .fullScreen
                present(tabBarViewController, animated: false, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = .ypBlack
//        imageView.image = UIImage(named: "imageFeedLogo")
        print("imageView loaded")
//        performSegue(withIdentifier: ShowAuthVCSegueIdentifier, sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("in segue")
//        if segue.identifier == ShowAuthVCSegueIdentifier {
//            guard
//                let viewController = segue.destination as? UINavigationController
////                let indexPath = sender as? IndexPath
//            else {
//                print("1")
//                assertionFailure("Invalid seque destination")
//                return
//            }
//            print("2")
////            viewController.pushViewController(UINavigationController, animated: <#T##Bool#>)
////            view.window?.rootViewController = viewController
////            view.window?.makeKeyAndVisible()
////            let image = UIImage(named: photosName[indexPath.row])
////            viewController.image = image
//        } else {
//            print("3")
//            super.prepare(for: segue, sender: sender)
//        }
//    }
//        
        
//        if segue.identifier == ShowAuthVCSegueIdentifier {
//            guard let UINavigationController = segue.destination as? UINavigationController
//            else { fatalError("Failed to prepare for \(ShowAuthVCSegueIdentifier)") }
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
    
}
