//
//  AuthPage.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import XCTest

final class AuthPage: BasePage {
    var authenticateButton: XCUIElement {
        app.buttons["Authenticate"]
    }
}
