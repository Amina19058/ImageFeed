//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 09.03.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
