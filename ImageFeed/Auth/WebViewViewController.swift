//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 31.01.2025.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(
        _ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {

    weak var delegate: WebViewViewControllerDelegate?

    // MARK: - @IBOutlet properties

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet private var webView: WKWebView!

    private var estimatedProgressObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthView()

        estimatedProgressObservation = webView.observe(
            \.estimatedProgress, options: [],
            changeHandler: { [weak self] _, _ in
                guard let self else { return }
                self.updateProgress()
            })
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }

    private func loadAuthView() {
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
        webView.load(request)
    }

    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(
            self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new, context: nil)
        updateProgress()

    }
    override func viewDidDisappear(_ animated: Bool) {
        webView.removeObserver(
            self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    override func observeValue(
        forKeyPath keyPath: String?, of object: Any?,
        change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(
                forKeyPath: keyPath, of: object, change: change,
                context: context)
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
