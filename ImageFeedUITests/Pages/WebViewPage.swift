//
//  WebViewPage.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import XCTest

final class WebViewPage: BasePage {
    var webView: XCUIElement {
        app.webViews["UnsplashWebView"]
    }
    
    var loginTextField: XCUIElement {
        webView.descendants(matching: .textField).element
    }
    
    var passwordTextField: XCUIElement {
        webView.descendants(matching: .secureTextField).element
    }
    
    var loginButton: XCUIElement {
        webView.buttons["Login"]
    }
}
