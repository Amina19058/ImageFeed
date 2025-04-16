//
//  WebViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 15.04.2025.
//

import Foundation
@testable import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
