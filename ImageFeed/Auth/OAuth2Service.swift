//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 04.09.2024.
//

import UIKit

struct OAuthTokenResponseBody: Codable {
    let access_token: String
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    private var finalRequest: URLRequest?
    var networkClient = NetworkClient()
    
    private func createURLRequest(_ code: String) {
        let baseURLString = "https://unsplash.com"
        let finalURLString = baseURLString + "/oauth/token"
        
        guard var urlComponents = URLComponents(string: finalURLString) else {
            print("Error in creating URL string for authorization request")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else {
            print("Error of url from urlComponents.url for authorization request")
            return
        }
        finalRequest = URLRequest(url: url)
    }
    
    
    func fetchOAuthToken(code: String, handler: @escaping (Swift.Result<String, Error>) -> Void) {
        createURLRequest(code)
        guard var request = finalRequest else { return }
        request.httpMethod = "POST"
        networkClient.fetch(request: request, handler: { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    handler(.success(response.access_token))
                } catch(let error) {
                    print("Decoder error:", error.localizedDescription)
                    handler(.failure(error))
                }
            case .failure(let error):
                print("fetch request error:", error.localizedDescription)
                handler(.failure(error))
            }
        })
    }
}
