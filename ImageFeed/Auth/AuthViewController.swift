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
    weak var delegate: AuthViewControllerDelegate?
    @IBOutlet weak var enterButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(ShowWebViewSegueIdentifier)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
            webViewViewController.modalPresentationStyle = .fullScreen
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func makeDelegate(_ delegate: AuthViewControllerDelegate) {
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.accessibilityIdentifier = "Authenticate"
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return}
            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success:
                self.dismiss(animated: false, completion: nil)
                self.delegate?.didAuthenticate(self, success: true)
            case .failure(let error):
                debugPrint("Authentication error: webViewViewController -> AuthViewController: \(error.localizedDescription)")
                self.dismiss(animated: false, completion: nil)
                self.delegate?.didAuthenticate(self, success: false)
                break
            }

        }
    }
}
