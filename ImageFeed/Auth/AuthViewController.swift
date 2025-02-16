//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 31.01.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service.shared
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowWebView" {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetch(code: code) { [weak self] result in
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    vc.dismiss(animated: true) {
                        self.delegate?.didAuthenticate(self)
                    }
                }
            case .failure(let error):
                print("Ошибка авторизации: \(error.localizedDescription)")
                self?.showErrorAlert()
            }
        }
    }
    private func showErrorAlert(){
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Попробуйте повторить авторизацию",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ошибка", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

