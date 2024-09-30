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
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        enterButton.isHidden = false
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if oauth2TokenStorage.token == nil || oauth2TokenStorage.token == "" {
//            enterButton.isHidden = false
//        } else {
//            enterButton.isHidden = true
//        }
        
//        configureBackButton()
        //        guard var token = oauth2TokenStorage.token else { return }
//        print("oauth2TokenStorage.token in viewDidLoad -> AuthViewController:  \(String(describing: oauth2TokenStorage.token))")
        //        if oauth2TokenStorage.token == nil {
        //            oauth2TokenStorage.token = ""
        //        }
    }
    
//    private func configureBackButton() {
//        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "ypBlack")
//    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
//        vc.dismiss(animated: true) // удаляет все открытые окна
//        authErrorAlert()

        UIBlockingProgressHUD.show()
        //        ProgressHUD.animate()
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return}
            UIBlockingProgressHUD.dismiss()
            //            ProgressHUD.dismiss()
            print("Thread main:", Thread.isMainThread)

            switch result {
//            case .success:
            case .success(let accessCode):
                print("accessCode in AuthViewController: WebViewViewControllerDelegate \(accessCode)")
//                self.authErrorAlert()
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Authentication error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.authErrorAlert()
                }
                break
            }
        }
        print("after closure in \(#function)")
//        authErrorAlert()
    }
    
    private func authErrorAlert() {
        print("in Alert method in AuthVC")
        let alertText = "OK"
        let alertTitle = "Что-то пошло не так ((("
        let alertMessage = "Не удалось войти в систему"
//        print("top most VC \(UIApplication.shared.windows[0].rootViewController)")
        guard var rootVC = UIApplication.shared.windows[0].rootViewController else { return }
        print("\(rootVC)")

        let alert = UIAlertController(
            /// заголовок всплывающего окна
            title: alertTitle,
            /// текст во всплывающем окне
            message:  alertMessage,
            /// preferredStyle может быть .alert или .actionSheet
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertText, style: .default) { _ in
            print("in UIAlertAction")
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
