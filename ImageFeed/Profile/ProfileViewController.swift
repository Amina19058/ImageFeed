//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 08.03.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var logoutButton: UIButton!
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
