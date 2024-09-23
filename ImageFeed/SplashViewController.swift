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
    private let profileService = ProfileService.shared
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("1. initial token:", oauth2TokenStorage.token)
        //TODO: сделать token optional
        if (oauth2TokenStorage.token == "") || (oauth2TokenStorage.token == nil) {
            print("do segue in SplashVC")
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        } else {
            print("swith to tabbar")
            guard let token = oauth2TokenStorage.token else { return }
            fetchProfileInSplashVC(token)
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
        print("didAuthenticate")
        vc.dismiss(animated: true)
        guard let token = oauth2TokenStorage.token else { return }
        fetchProfileInSplashVC(token)
    }
    
    private func fetchProfileInSplashVC(_ token: String) {
        print("1 in fetchProfileInSplashVC - SplashViewController")
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { result in
            UIBlockingProgressHUD.dismiss()
            print("2 fetchProfileInSplashVC token - ", token)
            print("3 in fetchProfileInSplashVC", self.description)
//            guard let self = self else {
//                print("in fetchProfileInSplashVC - error in self")
//                return
//            }
            switch result {
            case .success:
                print("2. in fetchProfileInSplashVC - profile")
//                profileService.profileUpdate(profileInt: profile)
                self.switchToTabBarViewController()
            case .failure(let error):
                print("Error profile loading", error.localizedDescription)
                break
            }
        }
    }
    
    
    private func switchToTabBarViewController() {
        print("in switchToTabBarViewController")
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
