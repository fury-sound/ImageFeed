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
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if oauth2TokenStorage.token == "" {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        } else {
            switchToTabBarViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = .ypBlack
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarViewController()
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
            viewController.modalTransitionStyle = .crossDissolve
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
