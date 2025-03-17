//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 23.12.2024.
//

import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject{
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImageListCellDelegate?
    
    var isLiked: Bool = false {
            didSet {
                let likeImage = isLiked ? UIImage(named: "Like_ON") : UIImage(named: "Like_OFF")
                likeButton.setImage(likeImage, for: .normal)
            }
        }
    // MARK: - @IBOutlet properties

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setIsLike(isLiked: Bool) {
         self.isLiked = isLiked
     }
    @IBAction func likeButtonTap(_ sender: Any) {
        isLiked.toggle()
        delegate?.imageListCellDidTapLike(self)
    }
    // MARK: - Static properties
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
        imageCell.image = nil
    }
    static let reuseIdentifier = "ImagesListCell"
}
