//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 24.09.2024.
//

import UIKit

struct UserResult: Codable {
    let profileImage: smallUserImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct smallUserImage: Codable {
    let smallImage: String?
    
    enum CodingKeys: String, CodingKey {
        case smallImage = "small"
    }
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var userResult: UserResult?
    private(set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
//        if task != nil {
//            task?.cancel()
//        }
        
        guard let token = oauth2TokenStorage.token else {
            handler(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        guard let request = createImageRequest(token, username) else {
            handler(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult,Error>) in
            guard let self else { return }
            switch result {
            case .success(let info):
                guard let avatarURL = info.profileImage?.smallImage else {return}
                handler(.success(avatarURL))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL" : avatarURL]
                )
            case .failure(let error):
                print("Decoder error:", error.localizedDescription)
                handler(.failure(error))
            }
//            self.task = nil
        }
        
//        let task1 = urlSession.data(for: request) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let data):
//                do {
//                    print("1 fetchProfileImageURL in do")
//                    let response = try JSONDecoder().decode(UserResult.self, from: data)
//                    self.avatarURL = response.profileImage?.smallImage
//                    guard let avatarURL = self.avatarURL else {return}
//                    //                    print(avatarURL)
//                    NotificationCenter.default.post(
//                        name: ProfileImageService.didChangeNotification,
//                        object: self,
//                        userInfo: ["URL" : avatarURL]
//                    )
////                    print("avatarURL after NotificationCenter", avatarURL)
//                    handler(.success(avatarURL))
//                } catch(let error) {
//                    print("Decoder error:", error.localizedDescription)
//                    handler(.failure(error))
//                }
//            case .failure(let error):
//                print("fetch image request error:", error.localizedDescription)
//                handler(.failure(error))
//            }
//            self.task = nil
//        }
        
        self.task = task
        task.resume()
    }
    
    private func createImageRequest(_ code: String, _ username: String) -> URLRequest? {
        let baseURLString = "https://api.unsplash.com"
        let finalURLString = URL(string: baseURLString + "/users/" + username)
        guard let url = finalURLString else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(code)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
