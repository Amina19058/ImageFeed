//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 02.03.2025.
//

import UIKit

private enum ImagesListCellUIConstants {
    static let likeButtonOnImageName = "like_button_on"
    static let likeButtonOffImageName = "like_button_off"
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = StoryboardIdentifiers.reuseCellIdentifier
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let imageName = isLiked ? ImagesListCellUIConstants.likeButtonOnImageName : ImagesListCellUIConstants.likeButtonOffImageName
        
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

extension ImagesListCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
}
