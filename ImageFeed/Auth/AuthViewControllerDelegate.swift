//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 13.09.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
    func authErrorAlert()
}
