//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 30.12.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
//    private let tokenStorage = OAuth2TokenStorage()
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    
    private let fullNameLable = UILabel()
    private let nikNameLable = UILabel()
    private let bioLable = UILabel()
    private let profilImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let profile = ProfileService.shared.profile else {
            return
        }
        updateUI(with: profile)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
        updateAvatar()
        // MARK: - PROFILEIMAGE
        

//        profilImage.image = UIImage(named: "avatar")
        profilImage.layer.cornerRadius = 35
        profilImage.clipsToBounds = true
        view.addSubview(profilImage)
        profilImage.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - EXITBUTTON
        
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
        
        // MARK: - FULLLABLE
        

//        fullNameLable.text = "Екатерина Новикова"
        fullNameLable.font = UIFont.boldSystemFont(ofSize: 23)
        fullNameLable.textColor = .white
        
        // MARK: - NICKNAMELABLE

//        nikNameLable.text = "@ekaterina_nov"
        nikNameLable.font = UIFont.systemFont(ofSize: 13)
        nikNameLable.textColor = .gray
        
        // MARK: - NICKNAMELABLE
        

//        bioLable.text = "Hello, world!"
        bioLable.font = UIFont.systemFont(ofSize: 13)
        bioLable.textColor = .white
        
        // MARK: - STACKLABLE
        
        let stackViewLable = UIStackView(arrangedSubviews: [fullNameLable, nikNameLable, bioLable])
        stackViewLable.axis = .vertical
        stackViewLable.spacing = 8
        stackViewLable.alignment = .leading
        stackViewLable.distribution = .equalCentering
        stackViewLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackViewLable)
        
        NSLayoutConstraint.activate([stackViewLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16), stackViewLable.topAnchor.constraint(equalTo: profilImage.bottomAnchor, constant: 8)])
    }
    private func updateUI(with profile: ProfileModel) {
        fullNameLable.text = profile.name
        nikNameLable.text = profile.loginName
        bioLable.text = profile.bio
     }
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL
        else { return }
        let imageURL = URL(string: profileImageURL)
        profilImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"))
    }
}
