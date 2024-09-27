//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 04.09.2024.
//

import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfilCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    //                    print("success with Network")
                    fulfilCompletionOnTheMainThread(.success(data))
                } else {
                    fulfilCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    print("status code error:", NetworkError.httpStatusCode(statusCode))
                }
            } else if let error = error {
                fulfilCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                print("Session error:, \(NetworkError.urlRequestError(error))")
            } else {
                fulfilCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                print("Generated data:", String(data: data ?? Data(), encoding: .utf8))
            }
        })
        return task
    }
        
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        OAuth2Service.shared.counter += 1
        print("1 objtask; counter \(OAuth2Service.shared.counter)")
        let task = data(for: request) { (result: Result<Data, Error>) in
            print("2 objtask")
            switch result {
            case .success(let info):
                print("3 objtask")
                do {
                    let response = try decoder.decode(T.self, from: info)
                    completion(.success(response))
                } catch(let error) {
                    print("Cannot decode JSON", error.localizedDescription)
                    completion(.failure(error))
                }
            case .failure(let error):
                print("4 objtask")
                print("Cannot receive JSON", error.localizedDescription)
                completion(.failure(error))
            }
        }
        return task
    }
    
}
