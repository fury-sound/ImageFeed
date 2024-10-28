//
//  ProfileViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 27.10.2024.
//

import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var calledAvatarURL: Bool = false
    var calledLogout: Bool = false
    
    func logoutAction() {
        calledLogout = true
    }
    
    func checkIfTokenIsRemoved() {
        
    }
    
    func tapLogout() {
        
    }
    
    func avatarURL() -> URL? {
        calledAvatarURL = true
        return nil
    }
    
    var delegate: ProfileViewControllerProtocol?
    
    
}

