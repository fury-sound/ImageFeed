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
    
    // обновление прогрессе в progressView
//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
//    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    
//    func load(request: URLRequest) {
//        webView.load(request)
//    }
    
    // переименован из func load(request: URLRequest)
    func loadAuthView(request: URLRequest) {
//        guard
//            var urlComponents = URLComponents(
//                string: WebViewConstants.unsplashAuthorizeURLString)
//        else {
//            debugPrint("Error creating urlComponents from URLComponents")
//            return
//        }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope),
//        ]
//        guard let url = urlComponents.url else {
//            debugPrint("Error of url from urlComponents.url")
//            return
//        }
//        let request = URLRequest(url: url)
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

//        if let url = navigationAction.request.url,
//           let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == "/oauth/authorize/native",
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            debugPrint("No code was received: code() -> WebViewViewController")
//            return nil
//        }
    }

    
}
