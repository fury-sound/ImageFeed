//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 31.08.2024.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
//    private var oauth2TokenStorage = OAuth2TokenStorage()
    private let keyChainStorage = KeyChainStorage()
    private let webViewViewController = WebViewViewController()
    //    var delegate = SplashViewController()
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
        //        guard var token = oauth2TokenStorage.token else { return }
//        print("oauth2TokenStorage.token in viewDidLoad -> AuthViewController:  \(String(describing: oauth2TokenStorage.token))")
        //        if oauth2TokenStorage.token == nil {
        //            oauth2TokenStorage.token = ""
        //        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
//        vc.dismiss(animated: true) // удаляет все открытые окна
        UIBlockingProgressHUD.show()
        //        ProgressHUD.animate()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return}
            UIBlockingProgressHUD.dismiss()
            //            ProgressHUD.dismiss()
            print("Thread main:", Thread.isMainThread)

            switch result {
            case .success:
//            case .success(let accessCode):
//                print("accessCode in AuthViewController: WebViewViewControllerDelegate \(accessCode)")
//                self.oauth2TokenStorage.token = accessCode
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Authentication error: \(error.localizedDescription)")
                self.authErrorAlert()
            }
        }
//        authErrorAlert()
    }
    
    private func authErrorAlert() {
        print("in Alert method")
        let alertText = "OK"
        let alertTitle = "Что-то пошло не так ((("
        let alertMessage = "Не удалось войти в систему"
        
        let action = UIAlertAction(title: alertText, style: .default) { _ in
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
        }
        
        let alert = UIAlertController(
            /// заголовок всплывающего окна
            title: alertTitle,
            /// текст во всплывающем окне
            message:  alertMessage,
            /// preferredStyle может быть .alert или .actionSheet
            preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated:  true, completion:  nil)
    }
}
