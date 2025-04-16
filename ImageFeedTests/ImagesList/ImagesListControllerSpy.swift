//
//  ImagesListControllerSpy.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import Foundation
@testable import ImageFeed

final class ImagesListControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    var showAlertCalled = false
    var updateTableAtIndexPathCalled = false
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func showAlert() {
        showAlertCalled = true
    }
    
    func updateTable(at indexPath: IndexPath) {
        updateTableAtIndexPathCalled = true
    }
}
