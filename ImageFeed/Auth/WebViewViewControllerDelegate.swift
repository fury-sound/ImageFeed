//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 01.09.2024.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
//    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
