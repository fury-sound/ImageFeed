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
    var networClient = NetworkClient()
    
    private func createURLRequest(_ code: String) {
        let baseURLString = "https://unsplash.com"
        let finalURLString = baseURLString + "/oauth/token"
//        + "?client_id=\(Constants.accessKey)"
//        + "&&client_secret=\(Constants.secretKey)"
//        + "&&redirect_uri=\(Constants.redirectURI)"
//        + "&&code=\(code)"
//        + "&&grant_type=authorization_code"
//        guard let urlString = URL(string: finalURLString)
//        else {
//            print("URL issue")
//            return
//        }
//        finalRequest = URLRequest(url: url)
        
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
//        print("final request: \(url)")
    }
    
    private func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                handler(.failure(NetworkError.urlRequestError(error)))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.httpStatusCode(response.statusCode)))
                print("status code error:", response.statusCode)
            }
            guard let data = data else {
                handler(.failure(NetworkError.urlSessionError))
                print("Generated data:", String(data: data ?? Data(), encoding: .utf8))
                return
            }
            handler(.success(data))
        })
        task.resume()
    }
    
    
    func fetchOAuthToken(code: String, handler: @escaping (Swift.Result<String, Error>) -> Void) {
        createURLRequest(code)
        guard var request = finalRequest else { return }
        request.httpMethod = "POST"
        print("in fetchOAuthToken")
        fetch(request: request, handler: { result in
            switch result {
            case .success(let data):
                print("success")
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    handler(.success(response.access_token))
//                    print("1", response)
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
