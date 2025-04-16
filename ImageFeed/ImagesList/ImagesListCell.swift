//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 02.03.2025.
//

import UIKit

protocol ImagesListCellProtocol {
    func setIsLiked(_ isLiked: Bool)
}

final class ImagesListCell: UITableViewCell & ImagesListCellProtocol {
    static let reuseIdentifier: String = .Storyboard.reuseCellIdentifier
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let imageName: String = isLiked ? .Assets.ImagesListCell.likeButtonOnImageName :
            .Assets.ImagesListCell.likeButtonOffImageName
        
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
}

extension ImagesListCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
}
