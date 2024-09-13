//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 31.08.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    private var oauth2TokenStorage = OAuth2TokenStorage()
    let webViewViewController = WebViewViewController()
    var delegate = SplashViewController()
    
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
        if oauth2TokenStorage.token.isEmpty {
            oauth2TokenStorage.token = ""
        }
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
        print("didAuthenticateWithCode success")
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let accessCode):
//                    print("success", accessCode)
                    print("Initial bearer token:", self.oauth2TokenStorage.token)
                    self.oauth2TokenStorage.token = accessCode
                    print("Current bearer token:", self.oauth2TokenStorage.token)
                    self.delegate.didAuthenticate(self)
                case .failure(let error):
                    print("Authentication error", error)
                }
            }
        }
    }
    
//    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
//        print("hiding webViewViewController")
//        dismiss(animated: true)
//    }
}
