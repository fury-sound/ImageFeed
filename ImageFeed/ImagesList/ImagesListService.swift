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
    var isLiked: Bool?
}

struct PhotoUnsplash: Codable {
    var anyPhoto: PhotoResult?
    
    enum CodingKeys: String, CodingKey {
        case anyPhoto = "photo"
    }
}

struct PhotoResult: Codable {
    let id: String?
    let width: Int?
    let height: Int?
    let createdAt: String?
    let welcomeDescription: String?
    var isLiked: Bool?
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
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var photo: Photo?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let dataFormatter = ISO8601DateFormatter()
    
    private func createImageRequest(_ token: String, _ pageNumber: Int) -> URLRequest? {
        var urlComponents = URLComponents()
        //примечание: к-во фото на страницу (per_page) проставлено как 5 - больше перезапусков приложения до исчерпания лимита подключений
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "5"),
        ]
        let urlString = Constants.baseAPIURLString + "/photos" + (urlComponents.string ?? "")
        let finalURLString = URL(string: urlString)
        guard let url = finalURLString else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func changeLikeRequest(_ token: String, photoId: String, isLike: Bool) -> URLRequest? {
        let urlString = Constants.baseAPIURLString + "/photos/" + photoId + "/like"
        let finalURLString = URL(string: urlString)
        guard let url = finalURLString else {return nil}
        var request = URLRequest(url: url)
        let methodIsLiked = isLike == true ? "POST" : "DELETE"
        request.httpMethod = methodIsLiked
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String?, isLike: Bool?, _ handler: @escaping (Result<Bool, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            task?.cancel()
        }
        
        guard let photoId, let isLike, let token = oauth2TokenStorage.token else {return}
        
        guard let request = changeLikeRequest(token, photoId: photoId, isLike: isLike) else {
            handler(.failure(ImageServiceError.invalidImageListRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<PhotoUnsplash, Error>) in
            self.task = nil
            switch result {
            case .success(let photoUnsplash):
                let isLike = photoUnsplash.anyPhoto?.isLiked ?? false
                handler(.success(isLike))
   
            case .failure(let error):
                debugPrint("Like symbol error:", error.localizedDescription)
                handler(.failure(error))
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func fetchPhotosNextPage(handler: @escaping (Result<[Photo], Error>) -> Void) {
        // Здесь получим страницу номер 1, если ещё не загружали ничего,
        // и следующую страницу (на единицу больше), если есть предыдущая загруженная страница
        
        assert(Thread.isMainThread)
        guard task == nil else { return }
                
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let token = oauth2TokenStorage.token else {
            handler(.failure(ImageServiceError.invalidImageListRequest))
            return
        }
        
        guard let request = createImageRequest(token, nextPage) else {
            handler(.failure(ImageServiceError.invalidImageListRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult],Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoResult):
                var photosInImageService: [Photo] = []
                for index in photoResult {
                    self.photo = Photo(id: index.id,
                                       size: CGSize(width: Double(index.width ?? 0), height: Double(index.height ?? 0)),
//                                       createdAt: dataFormatter.date(from: i.createdAt ?? "") ?? nil,
                                       createdAt: index.createdAt.flatMap({ self.dataFormatter.date(from: $0) }),
                                       welcomeDescription: index.welcomeDescription ?? "",
                                       thumbImageURL: index.urlsResult?.thumbImageURL ?? "",
                                       largeImageURL: index.urlsResult?.largeImageURL ?? "",
                                       isLiked: index.isLiked ?? false)
                    guard let photo = self.photo else {return}
                    photosInImageService.append(photo)
                }
                self.lastLoadedPage = nextPage
                handler(.success(photosInImageService))
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos" : photosInImageService]
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
    

    func removeImagesList() {
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }
    
}
