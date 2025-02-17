//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 23.12.2024.
//

import UIKit
final class ImagesListCell: UITableViewCell {
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    static let reuseIdentifier = "ImagesListCell"
}
