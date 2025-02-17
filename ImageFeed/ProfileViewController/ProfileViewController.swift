//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 30.12.2024.
//

import UIKit
final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PROFILEIMAGE
        let profilImage = UIImageView()
        profilImage.image = UIImage(named: "avatar")
        profilImage.layer.cornerRadius = 35
        profilImage.clipsToBounds = true
        view.addSubview(profilImage)
        profilImage.translatesAutoresizingMaskIntoConstraints = false
        
        // EXITBUTTON
        let exitButtom = UIButton()
        exitButtom.setImage(UIImage(named: "Exit"), for: .normal)
        view.addSubview(exitButtom)
        exitButtom.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            profilImage.heightAnchor.constraint(equalToConstant: 70),
            profilImage.widthAnchor.constraint(equalToConstant: 70),
            profilImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profilImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            exitButtom.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 24),
            exitButtom.centerYAnchor.constraint(equalTo: profilImage.centerYAnchor),
            exitButtom.leadingAnchor.constraint(equalTo: profilImage.trailingAnchor, constant: 241)
        ])
        
        // FULLLABLE
        let fullNameLable = UILabel()
        fullNameLable.text = "Екатерина Новикова"
        fullNameLable.font = UIFont.boldSystemFont(ofSize: 23)
        fullNameLable.textColor = .white
        
        //NICKNAMELABLE
        let nikNameLable = UILabel()
        nikNameLable.text = "@ekaterina_nov"
        nikNameLable.font = UIFont.systemFont(ofSize: 13)
        nikNameLable.textColor = .gray
        
        //BIOLABLE
        let bioLable = UILabel()
        bioLable.text = "Hello, world!"
        bioLable.font = UIFont.systemFont(ofSize: 13)
        bioLable.textColor = .white
        
        //STACKLABLE
        let stackViewLable = UIStackView(arrangedSubviews: [fullNameLable, nikNameLable, bioLable])
        stackViewLable.axis = .vertical
        stackViewLable.spacing = 8
        stackViewLable.alignment = .leading
        stackViewLable.distribution = .equalCentering
        stackViewLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackViewLable)
        
        NSLayoutConstraint.activate([stackViewLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16), stackViewLable.topAnchor.constraint(equalTo: profilImage.bottomAnchor, constant: 8)])
    }
}
