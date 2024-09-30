//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 22.09.2024.
//

import UIKit

private struct ProfileResult: Codable {
    var userName: String?
    var firstName: String?
    var lastName: String?
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

private struct ProfileImageURL: Codable {
    var smallImage: String?
    
    private enum CodingKeys: String, CodingKey {
        case smallImage = "small"
    }
}

struct Profile {
    var username: String?
    var name: String?
    var loginName: String?
    var bio: String?
    var imageURL: String?
}

enum ProfileServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    private var profileResult: ProfileResult?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    private func createURLRequest(_ code: String) -> URLRequest? {
        let baseURLString = "https://api.unsplash.com"
        let finalURLString = URL(string: baseURLString + "/me")
        guard let url = finalURLString else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(code)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    
    private func profileUpdate(profileInt: Profile) {
        guard var profile = self.profile else { return }
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
        
        let task = urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in

            switch result {
            case .success(let profileRes):
                self.profile = Profile(username: profileRes.userName ?? "",
                                       name: (profileRes.firstName ?? "") + " " + (profileRes.lastName ?? ""),
                                       loginName: "@" + (profileRes.userName ?? ""),
                                       bio: profileRes.bio ?? "") //, imageURL: imageTrueURL)
                guard let profile = self.profile else { return }
                handler(.success(profile))
            case .failure(let error):
                debugPrint("Cannot receive token, urlSession.objectTask -> fetchProfile -> ProfileService")
                handler(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
        
    }
}

    

