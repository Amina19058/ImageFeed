//
//  String+Extensions.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 13.04.2025.
//

extension String {
    enum Storyboard {
        static let main = "Main"
        
        static let reuseCellIdentifier = "ImagesListCell"
        
        static let showSingleImageSegueIdentifier = "ShowSingleImage"
        static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
        static let showWebViewSegueIdentifier = "ShowWebView"
        
        static let authViewController = "AuthViewController"
        static let tabBarViewController = "TabBarViewController"
        static let imagesListViewController = "ImagesListViewController"
    }
    
    enum Assets {
        enum Splash {
            static let logoImageName = "splash_screen_logo"
        }
        
        enum TabBar {
            static let profileItemImageName = "tab_profile_active"
        }
        
        enum ImagesListCell {
            static let likeButtonOnImageName = "like_button_on"
            static let likeButtonOffImageName = "like_button_off"
            static let placeholderImageName = "photo_placeholder"
        }
        
        enum Profile {
            static let photoImageName = "profile_photo"
            static let placeholderImageName = "profile_photo_placeholder"
            static let exitButtonImageName = "exit_button"
        }
        
        enum SingleImage {
            static let placeholderImageName = "photo_placeholder"
        }
    }
    
    enum Notification {
        static let imagesListServiceDidChange = "ImagesListServiceDidChange"
        static let profileImageProviderDidChange = "ProfileImageProviderDidChange"
    }
}

extension String {
    enum HTTPMethod {
        static let get = "GET"
        static let post = "POST"
        static let delete = "DELETE"
    }
}
