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
        self.name = "\(profileResult.firstName) \(profileResult.lastName)"
        self.bio = profileResult.bio
        self.loginName = profileResult.userName
    }
}
//struct Profile {
//    let username: String
//    let name: String
//    let loginName: String
//    let bio: String?
//    
//    init(profileResult: ProfileResult) {
//        self.username = profileResult.username
//        self.name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")".trimmingCharacters(in: .whitespaces)
//        self.loginName = "@\(profileResult.username)"
//        self.bio = profileResult.bio
//    }
//}
