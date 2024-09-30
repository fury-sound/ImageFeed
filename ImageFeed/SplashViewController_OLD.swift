//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 06.09.2024.
//

import UIKit
import SwiftKeychainWrapper

final class SplashViewController_OLD: UIViewController {
    /*
    private let ShowAuthVCSegueIdentifier = "toAuthVC"
//    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let keyChainStorage = KeyChainStorage()
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreenSegueIdentifier"
    private let showTabBarScreenSegueIdentifier = "showTabBarScreenSegueIdentifier"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    var flag2Change = true
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if flag2Change == true {
            KeychainWrapper.standard.removeObject(forKey: "bearerToken")
            flag2Change = false
        }
        print("1. initial token: \(String(describing: oauth2TokenStorage.token))")
        //TODO: сделать token optional
        if (oauth2TokenStorage.token == "") || (oauth2TokenStorage.token == nil) {
//            print("do segue in SplashVC")
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        } else {
//            print("swith to tabbar")
            guard let token = oauth2TokenStorage.token else { return }
            fetchProfileInSplashVC(token)
//            switchToTabBarViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.backgroundColor = .ypBlack
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
//        print("didAuthenticate")
        vc.dismiss(animated: true)
//        guard let token = oauth2TokenStorage.token else { return }
//        fetchProfileInSplashVC(token)
    }
    
    private func fetchProfileInSplashVC(_ token: String) {
//        print("1 in fetchProfileInSplashVC - SplashViewController")
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
//            print("token in  profileService.fetchProfile \(token)")
            guard let self else {
                print("error with self in fetchProfileInSplashVC")
                return
            }
//            print("2 fetchProfileInSplashVC token - ", token)
//            print("3 in fetchProfileInSplashVC", self.description)
//            guard let self = self else {
//                print("in fetchProfileInSplashVC - error in self")
//                return
//            }
            switch result {
            case .success:
//                print("2. in fetchProfileInSplashVC - profile")
//                profileService.profileUpdate(profileInt: profile)

                guard let userName = self.profileService.profile?.username else {
                    print("no username in fetchProfileInSplashVC")
                    return
                }
                self.profileImageService.fetchProfileImageURL(username: userName) { imageResult in
                    switch imageResult {
                    case .success(let avatarURLSent):
                        debugPrint("avatarURLSent successfully")
//                        debugPrint("avatarURL in SplashViewController", avatarURLSent)
                    case .failure(let error):
                        print("Can't download profile image", error.localizedDescription)
                    }
                }
                self.switchToTabBarViewController()
            case .failure(let error):
                print("Error profile loading", error.localizedDescription)
                break
            }
        }
    }
    
    
    private func switchToTabBarViewController() {
//        print("in switchToTabBarViewController")
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid windows configuration")
            return
        }
        let tabBarController = TabBarController()
//        guard var tabBarController else { return }
        tabBarController.awakeFromNib()
//        tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
//        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "ImagesListViewController")
        tabBarController.tabBar.barTintColor = .clear
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
     */
}
