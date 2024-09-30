//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 31.08.2024.
//

import UIKit
@preconcurrency import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString =
    "https://unsplash.com/oauth/authorize"
}

final class WebViewViewController: UIViewController {
    
    weak var delegate: WebViewViewControllerDelegate?
    weak var delegateSplashVC: SplashViewController?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonSetup()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
        webView.navigationDelegate = self
        loadAuthView()
        //        updateProgress() - old KVO
    }
    
    func backButtonSetup() {
        let buttonImage = UIImage(named: "nav_back_button")
        backButton.setImage(buttonImage, for: .normal)
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside) // back action
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    // подписка на наблюдателя - old KVO
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        webView.addObserver(
//            self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
//            options: .new, context: nil)
//        updateProgress()
//    }
     
    // отписываемся от наблюдателя - old KVO
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        webView.removeObserver(
//            self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
//            context: nil)
//    }
    
    //    обработчик обновлений свойства webView.estimatedProgress - old KVO
//    override func observeValue(
//        forKeyPath keyPath: String?,
//        of object: Any?,
//        change: [NSKeyValueChangeKey: Any]?,
//        context: UnsafeMutableRawPointer?
//    ) {
//        if keyPath == #keyPath(WKWebView.estimatedProgress) {
//            updateProgress()
//        } else {
//            super.observeValue(
//                forKeyPath: keyPath, of: object, change: change,
//                context: context)
//        }
//    }
    
    
//    @IBAction private func tapBackButton(_ sender: Any) {
//        guard let delegate else { return }
//        delegate.webViewViewControllerDidCancel(self)
//    }
    
    @objc private func tapBackButton() {
        guard let delegate else { return }
        delegate.webViewViewControllerDidCancel(self)
    }
    
    
    
    // обновление прогрессе в progressView
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView() {
        guard
            var urlComponents = URLComponents(
                string: WebViewConstants.unsplashAuthorizeURLString)
        else {
            print("Error creating urlComponents from URLComponents")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope),
        ]
        guard let url = urlComponents.url else {
            print("Error of url from urlComponents.url")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
//        let codeFromNavi = code(from: navigationAction)
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
//            print("in cancel - webView -> WebViewViewController")
            decisionHandler(.cancel)
        } else {
//            print("in allow - webView -> WebViewViewController")
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
//        let codeItem: [URLQueryItem]?
//        let urlCheck = navigationAction.request.url!
//        let urlComponentsCheck = URLComponents(string: urlCheck.absoluteString)!
//        let pathString = urlComponentsCheck.path
//        print("url params: \(urlCheck),\n \(urlComponentsCheck),\n \(pathString)")
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
//            print("codeItem.value \(codeItem.value!)")
            return codeItem.value
        } else {
//            let codeItem1 = urlComponentsCheck.queryItems?.first(where: { $0.name == "code" })
//            print("codeItem.value \(codeItem1)")
            debugPrint("No code was received")
            return nil
        }
    }

    
}
