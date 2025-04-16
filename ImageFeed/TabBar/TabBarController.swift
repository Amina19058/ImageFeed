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
        
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: .Storyboard.imagesListViewController
        ) as? ImagesListViewController else {
            print("Failed to instantiate ImagesListViewController")
            return
        }
        
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: .Assets.TabBar.profileItemImageName),
            selectedImage: nil
        )
        
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
