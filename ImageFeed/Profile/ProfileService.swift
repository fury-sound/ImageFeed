//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 22.09.2024.
//

import UIKit

struct ProfileResult: Codable {
    var userName: String
    var firstName: String
    var lastName: String
    var bio: String?
    var profileImageURL: ProfileImageURL?
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
        case profileImageURL = "profile_image"
    }
}

struct ProfileImageURL: Codable {
    var smallImage: String?
    
    private enum CodingKeys: String, CodingKey {
        case smallImage = "small"
    }
}

struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
    var imageURL: String?
}

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    var profileResult: ProfileResult? //= ProfileResult()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
   
    private func createURLRequest(_ code: String) -> URLRequest? {
        let baseURLString = "https://api.unsplash.com"
        let finalURLString = URL(string: baseURLString + "/me")
        print("in createURLRequest, token: \(code)")
        guard let url = finalURLString else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(code)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    func profileUpdate(profileInt: Profile) {
        guard var profile = self.profile else { return }
        print("in profileUpdate")
        profile.name = profileInt.name
        profile.loginName = profileInt.loginName
        if profileInt.bio != nil {
            profile.bio = profileInt.bio
        } else {
            profile.bio = "Hello, world!"
        }
    }
    
    func fetchProfile(_ token: String, handler: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        // избегаем гонку
        if task != nil {
            task?.cancel()
        } 
        
        guard let request = createURLRequest(token) else {
            handler(.failure(ProfileServiceError.invalidRequest))
            return
        }
//        print("request in fetchProfile: \(request), \(request.allHTTPHeaderFields)")

        let task = urlSession.data(for: request) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                print("in success do")
                do {
                    let response = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let imageURL = response.profileImageURL?.smallImage
//                    print(imageURL)
                    guard var profile = self.profile else { return }
                    profile = Profile(username: response.userName,
                                      name: response.firstName + " " + response.lastName,
                                      loginName: "@" + response.userName,
                                      bio: response.bio,
                                      imageURL: imageURL)
//                    print(profile)
                    handler(.success(profile))
                } catch(let error) {
                    print("Decoder error:", error.localizedDescription)
                    handler(.failure(error))
                }
            case .failure(let error):
                print("fetch request error:", error.localizedDescription)
                handler(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()

    }
    
}
