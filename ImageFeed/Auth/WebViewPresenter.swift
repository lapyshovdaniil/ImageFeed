//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 21.03.2025.
//
import UIKit
public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? {get set}
    func viewDidLoad()
}
final class WebViewPresenter: WebViewPresenterProtocol {
    func viewDidLoad() {
        guard
            var urlComponents = URLComponents(
                string: Constants.unsplashAuthorizeURLString)
        else {
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope),
        ]
        guard let url = urlComponents.url else {
            print("Ошибка при создание URL")
            return
        }
        let request = URLRequest(url: url)
        print(request)
        view?.load(request: request)
    }
    
    
    weak var view: WebViewViewControllerProtocol?
}
