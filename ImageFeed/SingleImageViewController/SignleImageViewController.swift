//
//  SignleImageViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 14.01.2025.
//

import UIKit

final class SignleImageViewController: UIViewController {

    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    // MARK: - @IBAction properties

    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image else {
            return
        }
        let activiryViewController = UIActivityViewController(
            activityItems: [image], applicationActivities: nil)
        present(activiryViewController, animated: true, completion: nil)
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - @IBOutlet properties

    @IBOutlet weak var tapBackButton: UIButton!
    @IBOutlet weak var didTapShareButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        didTapShareButton.setTitle("", for: .normal)
        tapBackButton.setTitle("", for: .normal)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.5
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
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
extension SignleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    /*  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
     scrollView.setContentOffset(.zero, animated: true)
     }
     */
    func scrollViewDidEndZooming(
        _ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat
    ) {
        guard let view else { return }

        let visibleRectSize = scrollView.bounds.size
        let realSize = view.frame.size

        let horizontalInset = max(
            0, (visibleRectSize.width - realSize.width) / 2)
        let verticalInset = max(
            0, (visibleRectSize.height - realSize.height) / 2)

        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset)
    }
}
