//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 15.04.2025.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func changeLike(indexPath: IndexPath, cell: ImagesListCell)
    func fetchPhotosNextPage()
    func photosCount() -> Int
    func photo(at indexPath: IndexPath) -> Photo
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage { [weak self] (result: Result<[Photo], Error>) in
            guard let self else { return }

            switch result {
            case .success(let newPhotos):
                photos = newPhotos
                view?.updateTableViewAnimated()
                
            case .failure(let error):
                print("[fetchPhotosNextPage] Failed to fetch photos: \(error.localizedDescription)")
                view?.showAlert()
            }
        }
    }
    
    
    func changeLike(indexPath: IndexPath, cell: ImagesListCell) {
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
                view?.showAlert()
            }
            
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func photosCount() -> Int { return photos.count }
    
    func photo(at indexPath: IndexPath) -> Photo { photos[indexPath.row] }
}

