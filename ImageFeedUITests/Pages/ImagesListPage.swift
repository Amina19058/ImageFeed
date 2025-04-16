//
//  ImagesListPage.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import XCTest

final class ImagesListPage: BasePage {
    private var tablesQuery: XCUIElementQuery {
        app.tables
    }
    
    var cells: [ImageCellElement] {
        tablesQuery.children(matching: .cell)
            .allElementsBoundByIndex
            .map { ImageCellElement(container: $0) }
    }
    
    var cellFirstMatch: XCUIElement {
        tablesQuery.children(matching: .cell).firstMatch
    }
}

struct ImageCellElement {
    let container: XCUIElement
    
    var likeButton: XCUIElement {
        return container.buttons["likeButton"].firstMatch
    }
}
