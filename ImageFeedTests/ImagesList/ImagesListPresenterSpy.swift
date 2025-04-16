//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import Foundation
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    private var photos: [Photo] = []
        
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func changeLike(indexPath: IndexPath, cell: ImagesListCellProtocol) { }
    
    func fetchPhotosNextPage() { }
    
    func photosCount() -> Int {
        photos.count
    }
    
    func photo(at indexPath: IndexPath) -> ImageFeed.Photo {
        return Photo(
            id: "id",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: nil,
            thumbImageURL: "https://thumbImageURL",
            largeImageURL: "https://largeImageURL",
            isLiked: false
        )
    }
}
