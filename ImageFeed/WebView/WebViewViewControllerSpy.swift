//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 27.10.2024.
//

import Foundation

final class WebViewViewControllerSpy: WebViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func loadAuthView(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
         
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
