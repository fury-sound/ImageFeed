//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Valery Zvonarev on 18.08.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
//    var image: UIImage? {
//        didSet {
//            guard isViewLoaded, let image else { return }
//            imageView.image = image
//            imageView.frame.size = image.size
//            rescaleAndCenterImageInScrollView(image: image)
//        }
//    }
    
    var urlLargePhoto: URL?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else {return}
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSingleImageView()
        loadSinglePhoto()
    }

    private func setupSingleImageView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func loadSinglePhoto() {
        guard let urlLargePhoto else { return }
        UIBlockingProgressHUD.show()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: urlLargePhoto) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else {return}
            switch result {
            case .success(let largeImage):
                self.imageView.frame.size = largeImage.image.size
                self.rescaleAndCenterImageInScrollView(image: largeImage.image)
            case .failure(let error):
                print("Cannot show individual image: \(error.localizedDescription)")
                self.showAlertError()
            }
        }
    }
    
    private func showAlertError() {
            let alert = UIAlertController(
                title: "Что-то пошло не так...(",
                message: "Попробовать еще раз?",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "Повторить?", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
                self.loadSinglePhoto()
            })
            let cancel = UIAlertAction(title: "Не надо!", style: .cancel, handler: nil)
            
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImagePosition()
    }
    
    private func centerImagePosition() {
        if scrollView.bounds.size.width > scrollView.contentSize.width {
            let insetSizeForWidth = (scrollView.bounds.size.width - scrollView.contentSize.width) / 2
            scrollView.contentInset.left = insetSizeForWidth
        }
        if scrollView.bounds.size.height > scrollView.contentSize.height {
            let insetSizeForHeight = (scrollView.bounds.size.height - scrollView.contentSize.height) / 2
            scrollView.contentInset.top = insetSizeForHeight
        }
    }
}
