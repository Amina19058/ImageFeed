//
//  ImagesListCellSpy.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 16.04.2025.
//

import Foundation
@testable import ImageFeed

final class ImagesListCellSpy: ImagesListCellProtocol {
    var setIsLikedCalled: Bool = false
    
    func setIsLiked(_ isLiked: Bool) {
        setIsLikedCalled = true
    }
}
