//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 23.12.2024.
//

import UIKit
final class ImagesListCell: UITableViewCell {

    // MARK: - @IBOutlet properties

    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Static properties
    
    @IBAction func Like(_ sender: Any) {

        print("выход")
    }
    static let reuseIdentifier = "ImagesListCell"
}
