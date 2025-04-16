//
//  ViewController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 23.02.2025.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }

    func updateTableViewAnimated()
    func showAlert()
    func updateTable(at indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    var presenter: ImagesListPresenterProtocol?
    
    @IBOutlet private var tableView: UITableView!
    private let showSingleImageSegueIdentifier: String = .Storyboard.showSingleImageSegueIdentifier
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath,
                let presenter
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let photo = presenter.photo(at: indexPath)
            
            viewController.imageUrl = URL(string: photo.largeImageURL)
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photosCount() ?? 0
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
        
        if ProcessInfo.processInfo.arguments.contains("UITests") {
            return
        }
        
        guard let presenter else { return }
        if indexPath.row + 1 == presenter.photosCount() {
            presenter.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let presenter else { return }
        
        let photo = presenter.photo(at: indexPath)
        
        guard let url = URL(string: photo.thumbImageURL) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url,
                                   placeholder: UIImage(named: .Assets.ImagesListCell.placeholderImageName)) { [weak self] result in
            switch result {
            case .success:
                print("[updateAvatar] Profile image updated successfully")
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure:
                print("[updateAvatar] Fail to update profile image")
            }
        }
        
        if let photoDate = photo.createdAt {
            cell.dateLabel.text = photoDate.dateString
        } else {
            cell.dateLabel.text = ""
        }
        
        let isLiked = photo.isLiked
        let likeImage = isLiked ? UIImage(named: .Assets.ImagesListCell.likeButtonOnImageName) : UIImage(named: .Assets.ImagesListCell.likeButtonOffImageName)
        
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else { return 0 }
        
        let image = presenter.photo(at: indexPath)
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / image.size.width
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController {
    func updateTableViewAnimated() {
        guard let presenter else { return }
        
        let oldCount = tableView.numberOfRows(inSection: 0)
        let newCount = presenter.photosCount()
                
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
        guard
            let indexPath = tableView.indexPath(for: cell),
            let presenter
        else { return }
        
        presenter.changeLike(indexPath: indexPath, cell: cell)

    }
    
    func updateTable(at indexPath: IndexPath) {
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showAlert() {
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
