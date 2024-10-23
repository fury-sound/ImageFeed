//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 06.09.2024.
//

import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        oauth2TokenStorage.token = ""
        if let token = oauth2TokenStorage.token, !token.isEmpty {
            windowCall(1)
        } else {
            switchToAuthViewController()
        }
    }
    
    
    func windowCall(_ route: Int) {
        guard let token = oauth2TokenStorage.token else {
            debugPrint("no token: windowCall -> splashVC")
            return
        }
        switch route {
        case 1:
            fetchProfileInSplashVC(token)
        case 2:
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
    
    func didAuthenticate(_ vc: AuthViewController, success: Bool) {
        if success {
            vc.presentingViewController?.dismiss(animated: true) { [weak self] in
                guard let self else {
                    debugPrint("error with self in didAuthenticate -> splashVC")
                    return
                }
                windowCall(1)
            }} else {
                vc.presentingViewController?.dismiss(animated: true) { [weak self] in
                    guard let self else {
                        debugPrint("error with self in didAuthenticate -> splashVC")
                        return
                    }
                    self.authErrorAlert()
                }}
    }
    
    private func fetchProfileInSplashVC(_ token: String) {
        var routeInt = 0

        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else {
                debugPrint("error with self in fetchProfileInSplashVC")
                return
            }
            switch result {
            case .success:
                routeInt = 2
            case .failure(let error):
                debugPrint("Error profile loading", error.localizedDescription)
                routeInt = 1
                break
            }
            
            guard let userName = self.profileService.profile?.username else {
                debugPrint("no username in fetchProfileInSplashVC")
                return
            }
            
            profileImageService.fetchProfileImageURL(username: userName) { imageResult in
                switch imageResult {
                case .success:
                    routeInt = 2
                case .failure(let error):
                    debugPrint("Can't download profile image: profileImageService.fetchProfileImageURL -> fetchProfileInSplashVC", error.localizedDescription)
                    routeInt = 1
                }
            }
            windowCall(routeInt)
        }
    }
    
    private func switchToAuthViewController() {
        
        guard let authViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {return}
        
        authViewController.makeDelegate(self)
        authViewController.modalPresentationStyle = .fullScreen
        authViewController.modalTransitionStyle = .crossDissolve
        present(authViewController, animated: true)
}
    
    private func switchToTabBarViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid windows configuration")
            return
        }
        let tabBarController = TabBarController()
        tabBarController.awakeFromNib()
        tabBarController.tabBar.barTintColor = .clear
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .fullScreen
        window.rootViewController = tabBarController
    }
    
    private func authErrorAlert() {
        let alertText = "OK"
        let alertTitle = "Что-то пошло не так ((("
        let alertMessage = "Не удалось войти в систему"

        let alert = UIAlertController(
            /// заголовок всплывающего окна
            title: alertTitle,
            /// текст во всплывающем окне
            message:  alertMessage,
            /// preferredStyle может быть .alert или .actionSheet
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertText, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        
        guard let rootVC = UIApplication.shared.windows[0].rootViewController else { return }
        if var topController = rootVC.presentedViewController {
            while let presented = topController.presentedViewController {
                topController = presented
            }
            topController.present(alert, animated: true)
            return
        }
        rootVC.present(alert, animated: true)
    }

    
}
