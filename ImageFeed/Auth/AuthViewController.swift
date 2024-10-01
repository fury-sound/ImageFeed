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
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func makeDelegate(_ delegate: AuthViewControllerDelegate) {
        self.delegate = delegate
    }
    
    override func viewDidAppear(_ animated: Bool) {

        guard let delegate else { return }
        view.insertSubview(delegate as? UIView ?? UIView(), at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.delegate?.didAuthenticate(self)
                dismiss(animated: false, completion: nil)
            case .failure(let error):
                debugPrint("Authentication error: webViewViewController -> AuthViewController: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.authErrorAlert()
                }
                break
            }
        }
    }
    
    private func authErrorAlert() {
        let alertText = "OK"
        let alertTitle = "Что-то пошло не так ((("
        let alertMessage = "Не удалось войти в систему"
        guard var rootVC = UIApplication.shared.windows[0].rootViewController else { return }

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
