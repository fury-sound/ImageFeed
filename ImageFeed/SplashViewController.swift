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
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreenSegueIdentifier"
    private let showTabBarScreenSegueIdentifier = "showTabBarScreenSegueIdentifier"
    //    var authViewController = AuthViewController()
    
    //    : UserDefaults = .standard
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if oauth2TokenStorage.token == "" {
            print("no token")
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        } else {
            print("token present")
            switchToTabBarViewController()
        }
    }
    
    func showNextVC(for id: String) {
        print("in showNextVC")
        if id == "AuthorizeVC" {
            //            if let naviViewController = storyboard?.instantiateViewController(withIdentifier: id) as? UINavigationController {
            //                naviViewController.modalTransitionStyle = .crossDissolve
            //                naviViewController.modalPresentationStyle = .fullScreen
            //                present(naviViewController, animated: false, completion: nil)
            //            }
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        } else {
            print("2")
            //            didAuthenticate(authViewController)
            
            //            if let tabBarViewController = storyboard?.instantiateViewController(withIdentifier: id) as?  UITabBarController {
            //                tabBarViewController.modalTransitionStyle = .crossDissolve
            //                tabBarViewController.modalPresentationStyle = .fullScreen
            //                present(tabBarViewController, animated: false, completion: nil)
            //            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = .ypBlack
        //        imageView.image = UIImage(named: "imageFeedLogo")
        print("imageView loaded")
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        print("in didAuthenticate")
        vc.dismiss(animated: true)
        switchToTabBarViewController()
        //        performSegue(withIdentifier: showTabBarScreenSegueIdentifier, sender: nil)
    }
    
    private func switchToTabBarViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid windows configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        window.rootViewController = tabBarController
    }
    
//    func switchToNavigationViewController(_ vc: ProfileViewController) {
////        vc.dismiss(animated: true)
//        oauth2TokenStorage.token = ""
//        performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.modalPresentationStyle = .fullScreen
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
