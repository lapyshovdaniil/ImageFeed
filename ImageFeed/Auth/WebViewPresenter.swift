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
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
final class WebViewPresenter: WebViewPresenterProtocol {
    var authHelper: AuthHelperProtocol
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {return}
        didUpdateProgressValue(0)
        print(request)
        view?.load(request: request)
    }
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    weak var view: WebViewViewControllerProtocol?
}
