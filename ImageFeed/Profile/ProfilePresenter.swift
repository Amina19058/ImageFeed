//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import Foundation


protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
//    func didTapLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private var profile: Profile?
    
    private var profileImageServiceObserver: NSObjectProtocol?

    func viewDidLoad() {
        guard let profile = profileService.profile else {
            print("[viewDidLoad] ProfilePresenter profile is nil")
            return
        }
        
        self.profile = profile
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                view?.updateAvatar()
            }
        
        view?.updateAvatar()
        view?.updateProfileDetails(profile: profile)
    }
    
    
}
