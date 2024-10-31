//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 31.08.2024.
//

import UIKit
@preconcurrency import WebKit

public protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? {get set}
    func loadAuthView(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

//enum WebViewConstants {
//    static let unsplashAuthorizeURLString =
//    "https://unsplash.com/oauth/authorize"
//}

final class WebViewViewController: UIViewController & WebViewControllerProtocol {

    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegate?
    weak var delegateSplashVC: SplashViewController?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonSetup()
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "WebViewViewController"
        presenter?.viewDidLoad()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func backButtonSetup() {
        let buttonImage = UIImage(named: "nav_back_button")
        backButton.setImage(buttonImage, for: .normal)
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside) // back button action
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    
    @objc private func tapBackButton() {
        guard let delegate else { return }
        delegate.webViewViewControllerDidCancel(self)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    
    // переименован из func load(request: URLRequest)
    func loadAuthView(request: URLRequest) {
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        } else {
            debugPrint("No code was received: code() -> WebViewViewController")
            return nil
        }
    }
}
