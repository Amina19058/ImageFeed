//
//  ViewController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 23.02.2025.
//

import UIKit
import Kingfisher

private enum ImagesListUIConstants {
    static let likeButtonOnImageName = "like_button_on"
    static let likeButtonOffImageName = "like_button_off"
    static let photoPlaceholderImageName = "photo_placeholder"
}

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let imagesListService = ImagesListService.shared
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private var photos: [Photo] = []
    private let showSingleImageSegueIdentifier = StoryboardIdentifiers.showSingleImageSegueIdentifier
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateTableViewAnimated()
            }
        
        imagesListService.fetchPhotosNextPage()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            viewController.imageUrl = URL(string: photos[indexPath.row].largeImageURL)
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            print("Failed to get imageListCell")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        imageListCell.delegate = self
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay: UITableViewCell , forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = imagesListService.photos[indexPath.row]
        
        guard let url = URL(string: photo.thumbImageURL) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url,
                                   placeholder: UIImage(named: ImagesListUIConstants.photoPlaceholderImageName)) { [weak self] result in
            switch result {
            case .success:
                print("[updateAvatar] Profile image updated successfully")
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure:
                print("[updateAvatar] Fail to update profile image")
            }
        }
        
        cell.dateLabel.text = Date().dateString
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: ImagesListUIConstants.likeButtonOnImageName) : UIImage(named: ImagesListUIConstants.likeButtonOffImageName)
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / image.size.width
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        photos = imagesListService.photos
        
        guard newCount - oldCount > 0 else { return }
        
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                photos = imagesListService.photos
                cell.setIsLiked(photos[indexPath.row].isLiked)
                
            case .failure:
                print("[imageListCellDidTapLike] Failed to change like")
                showAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось поменять лайк",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}
