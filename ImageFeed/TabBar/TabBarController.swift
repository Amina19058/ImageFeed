//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 06.04.2025.
//
import UIKit

private enum TabBarUIConstants {
    static let tabBarItemImageName = "tab_profile_active"
}

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: StoryboardIdentifiers.main, bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: StoryboardIdentifiers.imagesListViewController
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: TabBarUIConstants.tabBarItemImageName),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
