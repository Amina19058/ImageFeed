//
//  ProfileTests.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
