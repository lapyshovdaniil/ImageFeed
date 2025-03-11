//
//  ProfileModel.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 24.02.2025.
//
import UIKit

struct ProfileModel {
    let name: String
    let bio: String
    let loginName: String
    init(from profileResult: ProfileResult) {
        self.name = "\(profileResult.firstName) \(profileResult.lastName ?? "")"
        self.bio = profileResult.bio ?? ""
        self.loginName = profileResult.userName
    }
}

