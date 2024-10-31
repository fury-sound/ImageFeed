//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 27.10.2024.
//

import Foundation
import SwiftKeychainWrapper
import Kingfisher

public protocol ProfileViewPresenterProtocol: AnyObject {
    func logoutAction()
    func checkIfTokenIsRemoved()
    func tapLogout()
    func avatarURL() -> URL?
    var delegate: ProfileViewControllerProtocol? { get set }
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    private var oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    weak var delegate: ProfileViewControllerProtocol?

    func tapLogout() {
        delegate?.showAlert()
    }
    
    func avatarURL() -> URL? {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            debugPrint("No url for image in profileImageURL \(String(describing: profileImageService.avatarURL))")
            return nil
        }
        return url
    }
    
    func logoutAction() {
        oauth2TokenStorage.token = nil
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "bearerToken")
        ProfileLogoutService.shared.logout()
        profileService.profileRemove()
        profileImageService.profileImageRemove()
        ImagesListService.shared.removeImagesList()
//        delegate?.removeProfileInfo()
//        checkIfTokenIsRem.activityoved() // calling temporary function
    }
    
    // temporary function to clean all UserDefaults values
    func checkIfTokenIsRemoved() {
        // checking if bearerToken was removed
        let keyValue = "bearerToken"
        let isSuccess: String? = KeychainWrapper.standard.string(forKey: keyValue)
        guard isSuccess != nil else {
            debugPrint("token value is nil: isSuccess -> ProfileViewPresenter")
            return
        }
    }
    
}
