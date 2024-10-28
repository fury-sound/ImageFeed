//
//  Constants.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 29.08.2024.
//

import UIKit

enum Constants {
    static let accessKey = "ZnDa35lAWxEblgjxB4Mzq1WqGCeRKc0m80W7Jc97_ws"
    static let secretKey = "3sSTWFMTbD1LAhGCFDWnKGdSmzCrIRQrroyZ3GQyc6c"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let baseURLString = "https://unsplash.com"
    static let finalURLString = baseURLString + "/oauth/token"
    static let baseAPIURLString = "https://api.unsplash.com"
    static let finalURLStringMe = URL(string: baseAPIURLString + "/me")
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 authURLString: Constants.unsplashAuthorizeURLString)
    }
}


