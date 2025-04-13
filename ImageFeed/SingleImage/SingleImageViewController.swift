//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Amina Khusnutdinova on 09.03.2025.
//

import UIKit

private enum SingleImageUIConstants {
    static let photoPlaceholderImageName = "photo_placeholder"
}

final class SingleImageViewController: UIViewController {
    var imageUrl: URL? {
        didSet {
            guard isViewLoaded, let imageUrl else { return }
            setupImage()
        }
    }
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard imageUrl != nil else { return }
        setupImage()
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: false, completion: nil)
    }
    
    private func setupImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageUrl,
                              placeholder: UIImage(named: SingleImageUIConstants.photoPlaceholderImageName)) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.imageView.frame.size = imageResult.image.size
                rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Не надо", style: .default) { [weak self] _ in
            guard let self else { return }
            
            alert.dismiss(animated: true)
            didTapBackButton(self)
        }
        
        let reload = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            alert.dismiss(animated: true)
            self?.setupImage()
        }
        
        alert.addAction(cancel)
        alert.addAction(reload)
        
        self.present(alert, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
    
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
        
        scrollViewDidEndZooming(scrollView, with: imageView, atScale: scale)
    }
}
