//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import XCTest

final class ImageFeedUITests: BaseTestCase {
    private let authSteps = AuthSteps()
    private let webViewSteps = WebViewSteps()
    private let imagesListSteps = ImagesListSteps()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        authSteps
            .tapAuthButton()
        
        webViewSteps
            .checkWebViewExists()
            .login(email: "", password: "")
        
        imagesListSteps
            .checkCell(at: 0)
    }
    
    func testFeed() throws {
        imagesListSteps
            .checkCell(at: 0)
            .scrollToNextCell()
            .checkCell(at: 1)
            .checkCell(at: 1)
            .likeCell(at: 1)
        
        sleep(2)
        
        imagesListSteps
            .tapAtCell(at: 1)
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        
        app.buttons["logout button"].tap()
        
        app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes"].tap()
    }
}
