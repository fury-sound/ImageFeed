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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            //            debugPrint("No code was received")
            return nil
        }
    }
}
