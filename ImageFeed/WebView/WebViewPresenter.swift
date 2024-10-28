//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 26.10.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? {get set}
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString =
    "https://unsplash.com/oauth/authorize"
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { return }
        
        view?.loadAuthView(request: request)
        didUpdateProgressValue(0)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }

}
