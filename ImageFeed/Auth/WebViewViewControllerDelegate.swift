//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 24.03.2025.
//

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
