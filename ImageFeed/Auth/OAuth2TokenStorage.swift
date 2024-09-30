//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 04.09.2024.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
//    private let storage: UserDefaults = .standard
    private let storage: KeychainWrapper = .standard
    private enum Keys: String {
        case bearerToken
        case loadedFlag
    }
    
    var token: String? {
        get {
            storage.string(forKey: Keys.bearerToken.rawValue) //?? ""
        }
        set {
            storage.set(newValue ?? "", forKey: Keys.bearerToken.rawValue)
        }
    }

//    var profileLoaded: Bool {
//        get {
//            storage.bool(forKey: Keys.loadedFlag.rawValue) //?? ""
//        }
//        set {
//            storage.set(newValue, forKey: Keys.loadedFlag.rawValue)
//        }
//    }
}
