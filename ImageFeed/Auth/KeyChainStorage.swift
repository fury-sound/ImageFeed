//
//  KeyChainStorage.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 28.09.2024.
//

import UIKit
import SwiftKeychainWrapper

final class KeyChainStorage {
    private let storage: KeychainWrapper = .standard
    private enum Keys: String {
        case bearerToken
    }
    
    var token: String? {
        get {
            storage.string(forKey: Keys.bearerToken.rawValue) //?? ""
        }
        set {
            storage.set(newValue ?? "", forKey: Keys.bearerToken.rawValue)
        }
    }
}
