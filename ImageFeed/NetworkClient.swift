//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 04.09.2024.
//

import UIKit

struct NetworkClient {
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
    
}

