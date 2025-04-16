//
//  AuthSteps.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import XCTest

final class AuthSteps: BaseSteps {
    private var page: AuthPage = AuthPage()
    
    func tapAuthButton() {
        if page.alert.waitForExistence(timeout: 1) {
            page.alertOKButton.tap()
        }
        page.authenticateButton.waitForExistence(timeout: 5)
        page.authenticateButton.tap()
    }
}
