//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Даниил Лапышов on 31.01.2025.
//

import UIKit
import WebKit


public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(
        _ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {


    weak var delegate: WebViewViewControllerDelegate?
    
    var presenter: WebViewPresenterProtocol?

    // MARK: - @IBOutlet properties

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet private var webView: WKWebView!

    private var estimatedProgressObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
//        estimatedProgressObservation = webView.observe(
//            \.estimatedProgress, options: [],
//            changeHandler: { [weak self] _, _ in
//                guard let self else { return }
//                presenter?.didUpdateProgressValue(webView.estimatedProgress)
//            })
    }
    func load(request: URLRequest) {
        webView.load(request)
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        webView.addObserver(
            self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new, context: nil)
        presenter?.didUpdateProgressValue(webView.estimatedProgress)
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
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(
                forKeyPath: keyPath, of: object, change: change,
                context: context)
        }
    }

//    private func updateProgress() {
//        progressView.progress = Float(webView.estimatedProgress)
//        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
//    }
    func setProgressValue(_ newValue: Float){
        progressView.progress = newValue
    }
    func setProgressHidden(_ isHidden: Bool){
        progressView.isHidden = isHidden
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
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
