//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 03.04.2025.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    static func style() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .lightGray
    }
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
