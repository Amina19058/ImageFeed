//
//  ImagesListSteps.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import XCTest

final class ImagesListSteps: BaseSteps {
    private var page: ImagesListPage = ImagesListPage()
    
    @discardableResult
    func scrollToNextCell() -> Self {
        page.cellFirstMatch.swipeUp()
        sleep(2)
        
        return self
    }
    
    @discardableResult
    func likeCell(at index: Int) -> Self {
        guard let cell = getCell(at: index) else {
            XCTFail("Failed to like cell")
            return self
        }
        
        XCTAssertTrue(cell.container.waitForExistence(timeout: 5))
        cell.likeButton.tap()
        return self
    }
    
    @discardableResult
    func tapAtCell(at index: Int) -> Self {
        guard let cell = getCell(at: index) else {
            XCTFail("Failed to tap at cell")
            return self
        }
        
        XCTAssertTrue(cell.container.waitForExistence(timeout: 5))
        cell.container.tap()
        return self
    }
    
    @discardableResult
    func checkCell(at index: Int) -> Self {
        guard let cell = getCell(at: index) else {
            XCTFail("Failed to check cell")
            return self
        }
        
        XCTAssertTrue(cell.container.waitForExistence(timeout: 5))
        return self
    }
    
    private func getCell(at index: Int) -> ImageCellElement? {
        guard
            page.cellFirstMatch.waitForExistence(timeout: 5),
            index < page.cells.count
        else {
            XCTFail("Could not find cell at index \(index)")
            return nil
        }
        
        return page.cells[index]
    }
}
