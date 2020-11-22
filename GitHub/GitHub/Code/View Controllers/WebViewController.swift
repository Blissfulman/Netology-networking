//
//  WebViewController.swift
//  GitHub
//
//  Created by User on 26.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private var url: String!
    
    // MARK: - Initializers
    convenience init(url: String) {
        self.init()
        self.url = url
    }
    
    // MARK: - Lifecycle methods
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        injectJavaScript()
        
        guard let openingURL = URL(string: url) else { return }
        let urlRequest = URLRequest(url: openingURL)
        webView.load(urlRequest)
    }
    
    // MARK: - Private methods
    private func injectJavaScript() {
        let source = "document.body.style.backgroundColor = \"#0AAAA0\";"
        let userScript = WKUserScript(source: source,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        webView.reload()
    }
}

extension WebViewController: WKUIDelegate, WKNavigationDelegate {
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let host = navigationAction.request.url?.host {
            if host.contains("github.com") {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }
}
