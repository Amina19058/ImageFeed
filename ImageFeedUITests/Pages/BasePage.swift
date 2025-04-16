//
//  BasePage.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import XCTest

class BasePage: NSObject {
    let app: XCUIApplication
    
    required override init() {
        self.app = XCUIApplication.imageFeed
        super.init()
    }
}
