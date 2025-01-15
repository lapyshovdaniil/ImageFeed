//
//  SignleImageViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 14.01.2025.
//

import UIKit
class SignleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
