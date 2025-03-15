//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 09.03.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            guard let image else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: false, completion: nil)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(
        _ scrollView: UIScrollView,
        with view: UIView?,
        atScale scale: CGFloat
    ) {
        let visibleRectSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize

        let offX = max((visibleRectSize.width - contentSize.width) / 2, 0)
        let offY = max((visibleRectSize.height - contentSize.height) / 2, 0)

        scrollView.contentInset = UIEdgeInsets(top: offY, left: offX, bottom: offY, right: offX)
    }
    
//    func scrollViewDidEndZooming(_ scrollView: UIScrollView) {
//        let visibleRectSize = scrollView.bounds.size
//        let contentSize = scrollView.contentSize
//        
//        let offX = max((visibleRectSize.width - contentSize.width) / 2, 0)
//        let offY = max((visibleRectSize.height - contentSize.height) / 2, 0)
//        
//        scrollView.contentInset = UIEdgeInsets(top: offY, left: offX, bottom: offY, right: offX)
//    }
}

extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let vScale = visibleRectSize.height / imageSize.height
        let hScale = visibleRectSize.width / imageSize.width
        
        let theoreticalScale = min(hScale, vScale)
        
        let scale = min(maxZoomScale, max(minZoomScale, theoreticalScale))
        
        self.scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
                
//        let newContentSize = scrollView.contentSize
        
//        let x = (newContentSize.width - visibleRectSize.width) / 2
//        let y = (newContentSize.height - visibleRectSize.height) / 2
//        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
        scrollViewDidEndZooming(scrollView, with: imageView, atScale: scale)
    }
}
