//
//  WebViewNew.swift
//  TestTaskNews
//
//  Created by Мелкозеров Данила on 22.04.2022.
//

import UIKit
import WebKit

class NewsWebView: UIViewController {

    var newURL = ""
    let webView = WKWebView()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        configureWebview()
        setWebViewConstraints()
        
        navigationItem.titleView = activityIndicator
    }
    
    private func configureWebview() {
        guard let url = URL(string: newURL) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = self
        view.backgroundColor = .secondarySystemBackground
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setWebViewConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension NewsWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
