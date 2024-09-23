//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 04.09.2024.
//

import UIKit

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            storage.string(forKey: Keys.bearerToken.rawValue) //?? ""
        }
        set {
            storage.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
