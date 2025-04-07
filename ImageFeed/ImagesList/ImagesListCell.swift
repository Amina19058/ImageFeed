//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 02.03.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = StoryboardIdentifiers.reuseCellIdentifier
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
}
