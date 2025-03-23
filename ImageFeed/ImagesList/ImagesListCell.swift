//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 23.12.2024.
//

import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImageListCellDelegate?
    
    private var photo: Photo?
    
    var isLiked: Bool = false {
        didSet {
            let likeImage = isLiked ? UIImage(named: "Like_ON") : UIImage(named: "Like_OFF")
            likeButton.setImage(likeImage, for: .normal)
        }
    }
    
    // MARK: - @IBOutlet properties
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Configuration
    func configure(with photo: Photo, dateFormatter: DateFormatter) {
        self.photo = photo
        self.isLiked = photo.isLiked
        dateLabel.text = photo.createdAt.map { dateFormatter.string(from: $0) } ?? ""
        
        if let imageURL = URL(string: photo.thumbImageURL) {
            imageCell.kf.indicatorType = .activity
            imageCell.kf.setImage(with: imageURL, placeholder: UIImage(named: "Stub_placeholder")) { result in
                switch result {
                case .success(let value):
                    self.imageCell.image = value.image
                case .failure(let error):
                    print("Error loading image: \(error)")
                    self.imageCell.image = UIImage(named: "placeholder")
                }
            }
        } else {
            imageCell.image = UIImage(named: "placeholder")
        }
    }
    
    func setIsLike(isLiked: Bool) {
        self.isLiked = isLiked
    }
    
    // MARK: - Actions
    @IBAction private func likeButtonTap(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Cell Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
        imageCell.image = nil
        dateLabel.text = nil
        isLiked = false
    }
    
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
}


