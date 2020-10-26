//
//  WebViewController.swift
//  GitHub
//
//  Created by User on 26.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
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
        
        guard let openingURL = URL(string: url) else { return }
        let urlRequest = URLRequest(url: openingURL)
        webView.load(urlRequest)
    }
}
