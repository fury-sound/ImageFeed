//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 31.08.2024.
//

import UIKit
import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
//    static let unsplashAuthorizeURLString = "https://3commas.io/login"
}

final class WebViewViewController: UIViewController {
    
    weak var delegate: WebViewViewControllerDelegate?
    
    weak var delegateSplashVC: SplashViewController?

    @IBOutlet private weak var webView: WKWebView!
    
    @IBOutlet private weak var progressView: UIProgressView!
    
//    @IBAction func didTypeBackButton(_sender: Any) {
//        print("print back button")
//        delegate?.webViewViewControllerDidCancel(self)
//    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthView()
        updateProgress()
    }
    
    // подписка на наблюдателя
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        updateProgress()
    }

    // отписываемся от наблюдателя
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    
//    обработчик обновлений свойства webView.estimatedProgress
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // обновление прогрессе в progressView, вызывается в observeValue()
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView() {
        print("in loadAuthView")
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("Error creating urlComponents from URLComponents")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
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
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("in WebView")
        if let code = code(from: navigationAction) {
            //TODO: process code
//            print("CANCEL")
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
//            delegateSplashVC?.showNextVC(for: "ViewingDataVC")
            showTabBarVC()
        } else {
//            print("ALLOW")
            decisionHandler(.allow)
        }
    }
    
    func showTabBarVC() {
        print("in showTabBarVC")
        let id = "ViewingDataVC"
        if let tabBarViewController = storyboard?.instantiateViewController(withIdentifier: id) as?  UITabBarController {
            tabBarViewController.modalTransitionStyle = .crossDissolve
            tabBarViewController.modalPresentationStyle = .fullScreen
            present(tabBarViewController, animated: false, completion: nil)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
//        print("in code function")
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
//            print("codeItem present \(codeItem.value)")
            return codeItem.value
        } else {
            print("No code was received")
            return nil
        }
    }
}
