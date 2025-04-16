//
//  WebViewSteps.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import XCTest

final class WebViewSteps: BaseSteps {
    private var page: WebViewPage = WebViewPage()
    
    @discardableResult
    func checkWebViewExists() -> Self {
        XCTAssertTrue(page.webView.waitForExistence(timeout: 5))
        return self
    }
    
    func login(email: String, password: String) {
        XCTAssertTrue(page.loginTextField.waitForExistence(timeout: 5))
        
        page.loginTextField.tap()
        page.loginTextField.typeText(email)
        page.webView.swipeUp()
        
        XCTAssertTrue(page.passwordTextField.waitForExistence(timeout: 5))
        
        page.passwordTextField.tap()
        page.passwordTextField.typeText(password)
        page.webView.swipeUp()
        
        page.loginButton.tap()
    }
}
