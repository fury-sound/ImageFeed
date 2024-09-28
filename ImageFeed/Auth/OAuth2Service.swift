//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 04.09.2024.
//

import UIKit

struct OAuthTokenResponseBody: Codable {
    let access_token: String?
}

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    var counter = 0
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
//    private let oauth2Storage = OAuth2TokenStorage()
    private let keyChainStorage = KeyChainStorage()

    private init() {}
    //    private var finalRequest: URLRequest?
    //    var networkClient = NetworkClient()
    
    
    private func createURLRequest(_ code: String) -> URLRequest? {
        let baseURLString = "https://unsplash.com"
        let finalURLString = baseURLString + "/oauth/token"
        
        guard var urlComponents = URLComponents(string: finalURLString) else {
            print("Error in creating URL string for authorization request")
            return nil
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
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    
    func fetchOAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        //        createURLRequest(code)
        //        guard var request = finalRequest else { return }
        assert(Thread.isMainThread)
//        guard let lastCode = self.lastCode else {
//            print("lastCode error")
//            return
//        }
//        if task != nil {
//            if lastCode != code {
//                task?.cancel()
//            } else {
//                handler(.failure(AuthServiceError.invalidRequest))
//                return
//            }
//        } else {
//            if lastCode == code {
//                handler(.failure(AuthServiceError.invalidRequest))
//                return
//            }
//        }
        
        guard lastCode != code else {
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        self.lastCode = code
//        print("lastCode in fetchOAuthToken -> OAuth2Service, \(String(describing: self.lastCode)), \(String(describing: lastCode)); code: \(code)")
        guard let request = createURLRequest(code) else {
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error> ) in
            guard let self else { return }
            switch result {
            case .success(let info):
                guard let token = info.access_token else { return }
                keyChainStorage.token = token
//                print("token in new task: \(token), \(String(describing: keyChainStorage.token))")
                handler(.success(token))
            case .failure(let error):
                print("Cannot receive token in fetchOAuthToken, OAuth2Service")
                handler(.failure(error))
                self.lastCode = nil
            }
            self.lastCode = nil
            self.task = nil
        }
        
        self.task = task
        task.resume()
        
        //        let task = urlSession.data(for: request) { result in
        //            switch result {
        //            case .success(let token):
        //                do {
        //                    let response = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: token)
        //                    handler(.success(response.access_token!))
        //                } catch(let error) {
        //                    print("Decoder error:", error.localizedDescription)
        //                    handler(.failure(error))
        //                }
        //            case .failure(let error):
        //                print("fetch request error:", error.localizedDescription)
        //                handler(.failure(error))
        //                self.lastCode = nil
        //            }
        //            self.task = nil
        //        }
        

        
    }
}
