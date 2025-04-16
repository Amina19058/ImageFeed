//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 08.03.2025.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile)
    func updateAvatar()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    
    private var logoutButton: UIButton?
    
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileLogoutService = ProfileLogoutService.shared
    
    private enum DummyProfile {
        static let nameLabel = "Екатерина Новикова"
        static let loginNameLabel = "@ekaterina_nov"
        static let descriptionLabel = "Hello, world!"

    }
        
    override func viewDidLoad() {
        guard let presenter else { return }
        
        setupProfile()
        presenter.viewDidLoad()
    }
    
    private func setupProfile() {
        setupAvatarImageView()
        setupNameLabel()
        setupLoginName()
        setupDescriptionLabel()
        setupLogoutButton()
    }
    
    func updateProfileDetails(profile: Profile) {
        nameLabel?.text = profile.name
        loginNameLabel?.text = profile.loginName
        descriptionLabel?.text = profile.bio
    }
    
    private func setupAvatarImageView() {
        let profileImage = UIImage(named: .Assets.Profile.photoImageName)
        let imageView = UIImageView(image: profileImage)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        
        self.avatarImageView = imageView
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        self.avatarImageView?.kf.setImage(with: url,
                                          placeholder: UIImage(named: .Assets.Profile.placeholderImageName),
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
        nameLabel.text = DummyProfile.nameLabel
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
        loginNameLabel.text = DummyProfile.loginNameLabel
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
        descriptionLabel.text = DummyProfile.descriptionLabel
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
              let logoutImage = UIImage(named: .Assets.Profile.exitButtonImageName)
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
        logoutButton.accessibilityIdentifier = "logout button"
    }
    
    @objc
    private func didTapLogoutButton(_ sender: Any) {
        showLogoutAlert()
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            alert.dismiss(animated: true)
            
            self?.profileLogoutService.logout()
            
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            
            window.rootViewController = SplashViewController()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        alert.view.accessibilityIdentifier = "Bye bye!"

        self.present(alert, animated: true)
    }
}
