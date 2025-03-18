//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 8.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImageListViewController")
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Active_4"),
            selectedImage: nil
        )
        self.viewControllers = [
            imagesListViewController, profileViewController,
        ]
    }
}
