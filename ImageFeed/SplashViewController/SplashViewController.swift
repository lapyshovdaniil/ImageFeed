//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 11.02.2025.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private let storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreen"
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if let token = storage.token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
extension SplashViewController: AuthViewControllerDelegate{
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
    }
    
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fethcAuthToken(code)
        }
    }
    private func fethcAuthToken(_ code: String){
        oAuth2Service.fetch(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                break
            }
        }
    }
}
