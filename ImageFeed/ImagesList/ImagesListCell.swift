//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 23.12.2024.
//

import UIKit
 class ImagesListCell: UITableViewCell {
     @IBOutlet weak var ImageCell: UIImageView!
     @IBOutlet weak var LikeButton: UIButton!
     @IBOutlet weak var DateLabel: UILabel!
     static let reuseIdentifier = "ImagesListCell"
}
