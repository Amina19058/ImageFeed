//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 08.03.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    
    private var logoutButton: UIButton?
    
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    
    private var profile: Profile?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        setupPrifile()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        updateAvatar()
    }
    
    private func setupPrifile() {
        guard let profile = profileService.profile else {
            print("[setupPrifile] ProfileService profile is nil")
            return
        }
        
        self.profile = profile
        
        setupAvatarImageView()
        setupNameLabel()
        setupLoginName()
        setupDescriptionLabel()
        setupLogoutButton()
    }
    
    private func setupAvatarImageView() {
        let profileImage = UIImage(named: "profile_photo")
        let imageView = UIImageView(image: profileImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.avatarImageView = imageView
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        self.avatarImageView?.kf.setImage(with: url,
                              placeholder: UIImage(named: "profile_photo_placeholder"),
                                          options: [.processor(processor)]) { result in
            switch result {
            case .success:
                print("[updateAvatar] Profile image updated successfully")
            case .failure:
                print("[updateAvatar] Fail to update profile image")
            }
        }
    }
    
    private func setupNameLabel() {
        guard let avatarImageView = avatarImageView else { return }
        
        let nameLabel = UILabel()
        nameLabel.text = profile?.name
        nameLabel.font = .systemFont(ofSize: 23, weight: .semibold)
        nameLabel.textColor = .ypWhite
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.nameLabel = nameLabel
        view.addSubview(nameLabel)
        
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupLoginName() {
        guard let nameLabel = nameLabel else { return }
        
        let loginNameLabel = UILabel()
        loginNameLabel.text = profile?.loginName
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = .ypGray
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.loginNameLabel = loginNameLabel
        view.addSubview(loginNameLabel)
        
        loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupDescriptionLabel() {
        guard let loginNameLabel = loginNameLabel else { return }
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = profile?.bio
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = .ypWhite
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.descriptionLabel = descriptionLabel
        view.addSubview(descriptionLabel)
        
        descriptionLabel.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupLogoutButton() {
        guard let avatarImageView = avatarImageView,
        let logoutImage = UIImage(named: "exit_button")
        else { return }

        let logoutButton = UIButton.systemButton(
            with: logoutImage,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        logoutButton.tintColor = .ypRed
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.logoutButton = logoutButton
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc
    private func didTapLogoutButton(_ sender: Any) {
        oAuth2TokenStorage.clearToken()
    }
}
