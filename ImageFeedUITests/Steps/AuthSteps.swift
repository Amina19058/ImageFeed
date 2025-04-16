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
        page.authenticateButton.tap()
    }
}
