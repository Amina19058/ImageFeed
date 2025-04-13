//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 06.04.2025.
//
import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: .Storyboard.main, bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: .Storyboard.imagesListViewController
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: .Assets.TabBar.profileItemImageName),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
