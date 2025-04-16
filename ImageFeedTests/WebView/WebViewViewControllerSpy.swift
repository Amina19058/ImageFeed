//
//  WebViewViewControllerSpy.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 15.04.2025.
//

import Foundation
@testable import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
}
