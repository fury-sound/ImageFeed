//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 06.09.2024.
//

import UIKit
import SwiftKeychainWrapper

//final class SplashViewController: UIViewController, UINavigationControllerDelegate {
final class SplashViewController: UIViewController {
    //    private let ShowAuthVCSegueIdentifier = "toAuthVC"
    private let oauth2TokenStorage = OAuth2TokenStorage()
    //    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreenSegueIdentifier"
    //    private let showTabBarScreenSegueIdentifier = "showTabBarScreenSegueIdentifier"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var isProfileFetchSuccess = false
    private var isSplashActive = false
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.isSplashActive = true
        
        print("in viewDidAppear")

        print("token in keychain: \(KeychainWrapper.standard.string(forKey: "bearerToken"))")
        //        print("1. initial token: \(String(describing: keyChainStorage.token))")
        //        TODO: сделать token optional
        guard let token = oauth2TokenStorage.token else {
            print("no token in viewDidAppear -> splashVC")
            switchToAuthViewController()
            return
        }
        windowCall(1)

    }
    
    
    func windowCall(_ route: Int) {
        guard let token = oauth2TokenStorage.token else {
            print("no token in windowCall -> splashVC")
            return
        }
        switch route {
        case 1:
            print("go to fetchProfileInSplashVC, token: \(token)")
            fetchProfileInSplashVC(token)
        case 2:
            print("go to switchToTabBarViewController, token: \(token)")
            switchToTabBarViewController()
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashVC()
    }
    
    private func setupSplashVC() {
        view.backgroundColor = .ypBlack
        let logoImage = UIImage(named: "Logo_of_Unsplash")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.backgroundColor = .clear
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}



extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        print("didAuthenticate; token \(oauth2TokenStorage.token)")
        print("didAuthenticate isProfileFetchSuccess \(isProfileFetchSuccess)")
        vc.dismiss(animated: true) { [weak self] in
            print("in dismiss \(#function)")
            guard let self else {
                print("error with self in didAuthenticate -> splashVC")
                return
            }
//            guard let token = self.keyChainStorage.token else {
//                print("no token in didAuthenticate -> splashVC")
//                return
//            }
            print("inside dismiss closure")
            windowCall(1)
        }
    }
    
    private func showSplashVC() {
        view.backgroundColor = .ypBlack
        let logoImage = UIImage(named: "Logo_of_Unsplash")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.backgroundColor = .clear
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func fetchProfileInSplashVC(_ token: String) {
        print(#function)
        print(self.description)
        var routeInt = 0
        print("top most VC \(UIApplication.shared.windows[0].rootViewController)")
        print("top most VC \(UIApplication.shared.windows[0])")
        print("###############################################################")
        view.backgroundColor = .ypBlack
        let bgView = UIView()
        bgView.backgroundColor = .ypBlack
        let logoImage = UIImage(named: "imageFeedLogo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.backgroundColor = .clear
        view.addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgView.topAnchor.constraint(equalTo: view.topAnchor),
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 60)
        ])
//        setupSplashVC()
        //        print("1 in fetchProfileInSplashVC - SplashViewController")
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else {
                print("error with self in fetchProfileInSplashVC")
                return
            }
            switch result {
            case .success:
                routeInt = 2
            case .failure(let error):
                print("Error profile loading", error.localizedDescription)
                routeInt = 1
                break
            }
            
            guard let userName = self.profileService.profile?.username else {
                print("no username in fetchProfileInSplashVC")
                return
            }
            
            profileImageService.fetchProfileImageURL(username: userName) { imageResult in
                switch imageResult {
                case .success(let avatarURLSent):
                    debugPrint("avatarURLSent successfully")
                    routeInt = 2
                    //                        debugPrint("avatarURL in SplashViewController", avatarURLSent)
                case .failure(let error):
                    print("Can't download profile image", error.localizedDescription)
                    routeInt = 1
                }
            }
            logoImageView.removeFromSuperview()
            bgView.removeFromSuperview()
            windowCall(routeInt)
        }
    }
    
    private func switchToAuthViewController() {
        print("in switchToAuthViewController")
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid windows configuration")
            return
        }
        //        let authViewController = AuthViewController()
        //        authViewController.delegate = self
        //        authViewController.modalTransitionStyle = .crossDissolve
        //        authViewController.modalPresentationStyle = .fullScreen
        //        present(authViewController, animated: true)
        
        //        window.rootViewController = authViewController
        
        
//        let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "NavigationToAuthVC")
        guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AuthViewController") as? AuthViewController else {return}
        //        let authViewController = AuthViewController()
        //        authViewController.delegate = self
        authViewController.makeDelegate(self)
        authViewController.modalPresentationStyle = .fullScreen
        authViewController.modalTransitionStyle = .crossDissolve
        present(authViewController, animated: true)
        //        window.rootViewController = authViewController
        
        //        let naviToAuthViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "NavigationToAuthVC")
        //        let naviToAuthViewController = UINavigationController()
        //        naviToAuthViewController.delegate = self
        //        naviToAuthViewController.modalPresentationStyle = .fullScreen
        //        show(naviToAuthViewController, sender: self)
        //        window.rootViewController = naviToAuthViewController
        //        present(naviToAuthViewController, animated: true)
        
        
        //        authViewController.delegate = self
        //        authViewController.modalTransitionStyle = .crossDissolve
        //        authViewController.modalPresentationStyle = .fullScreen
        //        present(authViewController, animated: true)
        //        present(viewControllerToPresent: UIViewController, animated: true, completion: nil)
        
        //        window.rootViewController = naviToAuthViewController
    }
    
    private func switchToTabBarViewController() {
        //        print("in switchToTabBarViewController")
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid windows configuration")
            return
        }
//        dismiss(animated: false)
        
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
    
    func authErrorAlert() {
        print("in Alert method")
        let alertText = "OK"
        let alertTitle = "Что-то пошло не так ((("
        let alertMessage = "Не удалось войти в систему"
        
        let action = UIAlertAction(title: alertText, style: .default) { action in
            print("Wait for action")
        }
        //{ _ in
        //            self.keyChainStorage.token = nil
        //            print("Current token: \(String(describing: oauth2TokenStorage.token))")
        //        cleanUserDefaults() // calling temporary function
        //            self.dismiss(animated: true)
        //            guard let window = UIApplication.shared.windows.first else {
        //                assertionFailure("Invalid windows configuration")
        //                return
        //            }
        //            let splashViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "SplashViewVC")
        //            splashViewController.modalTransitionStyle = .crossDissolve
        //            splashViewController.modalPresentationStyle = .fullScreen
        //            window.rootViewController = splashViewController
        //        }
        
        let alert = UIAlertController(
            /// заголовок всплывающего окна
            title: alertTitle,
            /// текст во всплывающем окне
            message:  alertMessage,
            /// preferredStyle может быть .alert или .actionSheet
            preferredStyle: .alert)
        alert.addAction(action)
        print("top most VC \(UIApplication.shared.windows[0].rootViewController)")
        var topVC = UIApplication.shared.windows[0].rootViewController
        print("\(topVC)")
        guard let topVC else {
            print("No topVC")
            return
        }
        topVC.present(alert, animated: true, completion:  nil)
//        self.present(alert, animated:  true, completion:  nil)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == showAuthenticationScreenSegueIdentifier {
    //            guard
    //                let navigationController = segue.destination as? UINavigationController,
    //                let viewController = navigationController.viewControllers[0] as? AuthViewController
    //            else {
    //                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
    //                return
    //            }
    //            viewController.modalPresentationStyle = .fullScreen
    //            viewController.modalTransitionStyle = .crossDissolve
    //            viewController.delegate = self
    //        } else {
    //            super.prepare(for: segue, sender: sender)
    //        }
    //    }
}
