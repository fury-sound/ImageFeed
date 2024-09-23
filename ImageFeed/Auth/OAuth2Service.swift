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

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionDataTask?
    private var lastCode: String?
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
    
    
    private func convertJSONdataToString(data: Data) -> String {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
//            handler(.success(response.access_token))
            return response.access_token
        } catch(let error) {
            print("Decoder error:", error.localizedDescription)
            return "Decoder error:" + error.localizedDescription
//            handler(.failure(error))
            
        }
    }
    
    
    
    func fetchOAuthToken(code: String, handler: @escaping (Swift.Result<String, Error>) -> Void) {
        //        createURLRequest(code)
        //        guard var request = finalRequest else { return }
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                handler(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                handler(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        guard var request = createURLRequest(code) else {
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    handler(.failure(NetworkError.urlRequestError(error)))
                    print("Session error:, \(NetworkError.urlRequestError(error))")
                    return
                }
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    handler(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    print("status code error:", response.statusCode)
                    return
                }
                guard let data = data else {
                    handler(.failure(NetworkError.urlSessionError))
                    print("Generated data:", String(data: data ?? Data(), encoding: .utf8))
                    return
                }
                handler(.success(data))
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
        
        
        //        networkClient.fetch(request: request, handler: { result in
        //            switch result {
        //            case .success(let data):
        //                do {
        //                    let decoder = JSONDecoder()
        //                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
        //                    handler(.success(response.access_token))
        //                } catch(let error) {
        //                    print("Decoder error:", error.localizedDescription)
        //                    handler(.failure(error))
        //                }
        //            case .failure(let error):
        //                print("fetch request error:", error.localizedDescription)
        //                handler(.failure(error))
        //            }
        //        })
    }
}
