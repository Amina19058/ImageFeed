//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 30.03.2025.
//

import UIKit

private enum SplashUIConstants {
    static let splashLogoImageName = "splash_screen_logo"
}

final class SplashViewController: UIViewController {
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    private let showAuthenticationScreenSegueIdentifier = StoryboardIdentifiers.showAuthenticationScreenSegueIdentifier
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSplash()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oAuth2TokenStorage.token {
            fetchProfile(token)
        } else {
            showAuthViewController()
        }
    }
    
    private func setupSplash() {
        view.backgroundColor = .ypBlack
        
        let imageView = UIImageView(image: UIImage(named: SplashUIConstants.splashLogoImageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: StoryboardIdentifiers.main, bundle: .main)
            .instantiateViewController(withIdentifier: StoryboardIdentifiers.tabBarViewController)
           
        window.rootViewController = tabBarController
    }
    
    private func showAuthViewController() {
        let storyboard = UIStoryboard(name: StoryboardIdentifiers.main, bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: StoryboardIdentifiers.authViewController
        ) as? AuthViewController else {
            print("[SplashViewController] Failed to instantiate AuthViewController")
            return
        }
        
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            alert.dismiss(animated: true)
            self?.showAuthViewController()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = oAuth2TokenStorage.token else {
            assertionFailure("No token found")
            return
        }
        
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }

            switch result {
            case .success(let profile):
                print("Successfully obtained profile info")
                
                profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                
                self.switchToTabBarController()
                
            case .failure(let error):
                print("Error obtaining profile info: \(error)")
                showAlert()
            }
        }
    }
}
