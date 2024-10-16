//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 06.10.2024.
//

import UIKit

enum ImageServiceError: Error {
    case invalidImageListRequest
}

struct Photo {
    let id: String?
    let size: CGSize?
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool?
}

struct PhotoUnsplash: Codable {
    let allPhotos: PhotoResult
}

struct PhotoResult: Codable {
    let id: String?
    let width: Int?
    let height: Int?
    let createdAt: String?
    let welcomeDescription: String?
    let isLiked: Bool?
    let urlsResult: UrlsResult?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case welcomeDescription = "description"
        case createdAt = "created_at"
        case isLiked = "liked_by_user"
        case urlsResult = "urls"
    }
}

struct UrlsResult: Codable {
    let largeImageURL: String?
    let thumbImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case largeImageURL = "full"
        case thumbImageURL = "thumb"
    }
}

final class ImagesListService {
    static let shared = ImagesListService()
    private init() {}
    private var lastLoadedPage: Int?
    private(set) var photos: [Photo] = []
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var photo: Photo?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let dataFormatter = ISO8601DateFormatter()

    
    func fetchPhotosNextPage(handler: @escaping (Result<[Photo], Error>) -> Void) {
        // Здесь получим страницу номер 1, если ещё не загружали ничего,
        // и следующую страницу (на единицу больше), если есть предыдущая загруженная страница
//        guard let token = oauth2TokenStorage.token else { return }
        
        assert(Thread.isMainThread)
        print("Thread.isMainThread: \(Thread.isMainThread)")
        
        if task != nil {
            task?.cancel()
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        guard let token = oauth2TokenStorage.token else {
            handler(.failure(ImageServiceError.invalidImageListRequest))
            return
        }
        
//        guard let request = createImageRequest(token, nextPage) else {
        guard let request = createImageRequest(token, nextPage) else {
            handler(.failure(ImageServiceError.invalidImageListRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult],Error>) in
            print("in task")
            guard let self else { return }
            switch result {
            case .success(let photoResult):
                print("in .success")
//                let photoResult = PhotoResult(id: imageInfo.id,
//                                               width: imageInfo.width,
//                                               height: imageInfo.height,
//                                               createdAt: (imageInfo.createdAt ?? Date()),
//                                               welcomeDescription: (imageInfo.welcomeDescription ?? ""),
//                                               isLiked: imageInfo.isLiked,
//                                              urlsResult: imageInfo.urlsResult)
                for i in photoResult {
                    self.photo = Photo(id: i.id,
                                       size: CGSize(width: Double(i.width ?? 0), height: Double(i.height ?? 0)),
                                       createdAt: dataFormatter.date(from: i.createdAt ?? "") ?? Date(),
                                       welcomeDescription: i.welcomeDescription ?? "",
                                       thumbImageURL: i.urlsResult?.thumbImageURL ?? "",
                                       largeImageURL: i.urlsResult?.largeImageURL ?? "",
                                       isLiked: i.isLiked ?? false)
                    guard let photo = self.photo else {return}
                    photos.append(photo)
                }
                self.lastLoadedPage = nextPage
                print("1. photos count in urlSession.objectTask \(photos.count)")
                handler(.success(photos))
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos" : photos]
                )
            case .failure(let error):
                debugPrint("Decoder error:", error.localizedDescription)
                handler(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    
//    func createImageRequest(_ token: String) -> URLRequest? {
//            
//            guard let url = Constants.defaultBaseURL else { preconditionFailure("Incorrect URL") }
//            var page = "1"
//            var perPage = "10"
//            var request = URLRequest.setHTTPRequest(
//                path: "/photos?page=\(page)&&per_page=\(perPage)",
//                httpMethod: "GET",
//                url: url)
//            request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            return request
//        }
    
    
    private func createImageRequest(_ token: String, _ pageNumber: Int) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "10"),
        ]
        let urlString = Constants.baseAPIURLString + "/photos" + (urlComponents.string ?? "")
        print("url: \(urlString)")
        let finalURLString = URL(string: urlString)
        guard let url = finalURLString else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("request: \(request.description)")
//        print("request: \(request.allHTTPHeaderFields)")
        return request
    }
    
}

//extension URLRequest {
//    
//    static func setHTTPRequest(
//        path: String,
//        httpMethod: String,
//        url: URL = {
//            guard let url = Constants.defaultBaseURL else { preconditionFailure("IncorrectURL") }
//            return url
//        }()
//    ) -> URLRequest? {
//        guard let url = URL(string: path, relativeTo: url)
//        else {
//            return nil
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = httpMethod
//        return request
//    }
//}



