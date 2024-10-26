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
    static let finaAPIlURLString = URL(string: baseAPIURLString + "/me")
    
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")
}


