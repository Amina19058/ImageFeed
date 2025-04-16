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
    
    var alert: XCUIElement {
        app.alerts["profileErrorAlert"]
    }
    
    var alertOKButton: XCUIElement {
        alert.buttons["OK"].firstMatch
    }
}
