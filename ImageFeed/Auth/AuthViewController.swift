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
    private var oauth2TokenStorage = OAuth2TokenStorage()
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
        print("oauth2TokenStorage.token in viewDidLoad -> AuthViewController:  \(String(describing: oauth2TokenStorage.token))")
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
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
//        ProgressHUD.animate()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return}
            UIBlockingProgressHUD.dismiss()
//            ProgressHUD.dismiss()
            print("Thread main:", Thread.isMainThread)
//            DispatchQueue.main.async {
                switch result {
                case .success(let accessCode):
                    print("accessCode in AuthViewController: WebViewViewControllerDelegate \(accessCode)")
                    self.oauth2TokenStorage.token = accessCode
                    self.delegate?.didAuthenticate(self)
                case .failure(let error):
                    print("Authentication error", error)
                }
//            }
        }
    }
}
