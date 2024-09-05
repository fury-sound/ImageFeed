//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 04.09.2024.
//

import UIKit

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    
    var token: String {
        get {
            storage.string(forKey: "bearerToken")!
        }
        set {
            storage.set(newValue, forKey: "bearerToken")
        }
    }
}
