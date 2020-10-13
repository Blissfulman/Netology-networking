//
//  ViewController.swift
//  GitHub
//
//  Created by User on 11.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    // MARK: - Properties
    /// Изображение логотипа
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "username"
        textField.textContentType = .username
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.textContentType = .password
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.delegate = self

        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        setupLayout()
        
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
    }

    // MARK: - Setup UI
    private func  setupUI() {
        view.backgroundColor = .white

        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
               
        let url = URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png")
        logoImageView.kf.indicatorType = .activity
        logoImageView.kf.setImage(with: url)
    }
    
    // MARK: - Setup layout
    private func setupLayout() {
        let constraints = [
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                                 multiplier: 0.8),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor,
                                                  multiplier: 0.5),
            
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                                   constant: 100),
            usernameTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                                     multiplier: 0.7),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor,
                                                   constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Actions
    @objc private func tappedLoginButton() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}
