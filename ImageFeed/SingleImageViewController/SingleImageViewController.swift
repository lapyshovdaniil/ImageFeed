//
//  SignleImageViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 14.01.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {

    var imageURL: String?
    
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
        guard let imageURL else {
            return
        }
        let activiryViewController = UIActivityViewController(
            activityItems: [imageURL], applicationActivities: nil)
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
        loadImage(imageURL: imageURL ?? " ")
        didTapShareButton.setTitle("", for: .normal)
        tapBackButton.setTitle("", for: .normal)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.5
        configScrollView()
    }
    private func loadImage(imageURL: String) {
        if let imageURL = URL(string: imageURL) {
            UIBlockingProgressHUD.show()
            imageView.kf.setImage(with: imageURL) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                
                guard let self = self else { return }
                
                switch result {
                case .success(let imageResult):
                    self.imageView.image = imageResult.image
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image) 
                case .failure:
                    self.showError()
                }
            }
        }
    }
    private func configScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

}
extension SingleImageViewController: UIScrollViewDelegate {
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
    private func showError() {
          let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
          alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
              self.loadImage(imageURL: self.imageURL ?? " ")
          })
          present(alert, animated: true)
      }
}
