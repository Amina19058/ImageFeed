//
//  ImagesListTests.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: .Storyboard.main, bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(
            withIdentifier: .Storyboard.imagesListViewController
        ) as? ImagesListViewController else {
            XCTFail("Failed to instantiate ImagesListViewController")
            return
        }
        
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateTableViewAnimatedWhenSuccess() {
        //given
        let viewController = ImagesListControllerSpy()
        
        let mockService = ImagesListServiceSpy()
        
        let presenter = ImagesListPresenter(imagesListService: mockService)
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let photos: [Photo] = [Photo(
            id: "id",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: nil,
            thumbImageURL: "https://thumbImageURL",
            largeImageURL: "https://largeImageURL",
            isLiked: false
        )]
        
        mockService.fetchPhotosMockResult = .success(photos)
        
        //when
        presenter.fetchPhotosNextPage()
        
        //then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testPresenterCallsShowAlertWhenFailure() {
        //given
        let viewController = ImagesListControllerSpy()
        
        let mockService = ImagesListServiceSpy()
        
        let presenter = ImagesListPresenter(imagesListService: mockService)
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        mockService.fetchPhotosMockResult = .failure(ImagesListServiceError.error)
        
        //when
        presenter.fetchPhotosNextPage()
        
        //then
        XCTAssertTrue(viewController.showAlertCalled)
    }
    
    func testPresenterCallsShowAlertWhenChangeLikeFailed() {
        //given
        let viewController = ImagesListControllerSpy()
        
        let mockService = ImagesListServiceSpy()
        
        let photos: [Photo] = [Photo(
            id: "id",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: nil,
            thumbImageURL: "https://thumbImageURL",
            largeImageURL: "https://largeImageURL",
            isLiked: false
        )]
        
        let presenter = ImagesListPresenter(imagesListService: mockService, photos: photos)
        mockService.photos = photos
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        mockService.changeLikeMockResult = .failure(ImagesListServiceError.error)
        
        //when
        presenter.changeLike(indexPath: IndexPath(row: 0, section: 0), cell: ImagesListCell())
        
        //then
        XCTAssertTrue(viewController.showAlertCalled)
    }
    
    func testPresenterCallsShowAlertWhenChangeLikeSucceeded() {
        //given
        let viewController = ImagesListControllerSpy()
        
        let mockService = ImagesListServiceSpy()
        
        let photos: [Photo] = [Photo(
            id: "id",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: nil,
            thumbImageURL: "https://thumbImageURL",
            largeImageURL: "https://largeImageURL",
            isLiked: false
        )]
        
        let presenter = ImagesListPresenter(imagesListService: mockService, photos: photos)
        mockService.photos = photos
        
        let cell = ImagesListCellSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        mockService.changeLikeMockResult = .success(())
        
        //when
        presenter.changeLike(indexPath: IndexPath(row: 0, section: 0), cell: cell)
        
        //then
        XCTAssertTrue(cell.setIsLikedCalled)
    }
}

