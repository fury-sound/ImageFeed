//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 04.09.2024.
//

import UIKit

struct NetworkClient {
    private enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
    
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
        }
        
        task.resume()
    }
    
}

