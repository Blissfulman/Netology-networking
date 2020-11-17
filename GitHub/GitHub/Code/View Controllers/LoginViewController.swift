//
//  ViewController.swift
//  GitHub
//
//  Created by User on 11.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit
import Kingfisher

class LoginViewController: UIViewController {

    // MARK: - Properties
    /// Изображение логотипа
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "username"
        textField.textContentType = .username
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.textContentType = .password
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.clearsOnBeginEditing = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let requestManager = RequestManager.shared
    private let authenticationManager = AuthenticationManager.shared
    private let keychainManager = KeychainManager.shared
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        setupLayout()
        loginButton.addTarget(self,
                              action: #selector(loginButtonPressed),
                              for: .touchUpInside)
        
        guard let keychainData = keychainManager.getKeychainData() else { return }
        
        authenticationManager.authenticateUser(
            username: keychainData.username,
            password: keychainData.password
        ) { [weak self] in
            
            guard let `self` = self else { return }
            
            self.authorizeUser(username: keychainData.username,
                               password: keychainData.password)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        usernameTextField.text = nil
        passwordTextField.text = nil
    }
    
    // MARK: - Actions
    @objc private func loginButtonPressed() {
        
        view.endEditing(true)
        
        guard let username = usernameTextField.text, username != "",
              let password = passwordTextField.text, password != ""
        else { return }
        
        authorizeUser(username: username, password: password)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        let url = URL(string: RequestManager.urlGitHubLogo)
        logoImageView.kf.indicatorType = .activity
        logoImageView.kf.setImage(with: url)
    }
    
    // MARK: - Setup layout
    private func setupLayout() {
        let constraints = [
            logoImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100
            ),
            logoImageView.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            logoImageView.widthAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8
            ),
            logoImageView.heightAnchor.constraint(
                equalTo: logoImageView.widthAnchor, multiplier: 0.5
            ),
            
            usernameTextField.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor, constant: 100
            ),
            usernameTextField.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            usernameTextField.widthAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7
            ),
            
            passwordTextField.topAnchor.constraint(
                equalTo: usernameTextField.bottomAnchor, constant: 20
            ),
            passwordTextField.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            ),
            passwordTextField.widthAnchor.constraint(
                equalTo: usernameTextField.widthAnchor
            ),
            
            loginButton.topAnchor.constraint(
                equalTo: passwordTextField.bottomAnchor, constant: 50
            ),
            loginButton.centerXAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.centerXAnchor
            )
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Private methods
    private func authorizeUser(username: String, password: String) {
        
        requestManager.userAuthorization(username: username,
                                         password: password) {
            [weak self] (user) in
            
            guard let `self` = self else { return }
            
            guard let user = user else { return }
            
            DispatchQueue.main.async {
                let searchRepositoryViewController =
                    SearchRepositoryViewController(user: user)
                self.navigationController?.pushViewController(
                    searchRepositoryViewController, animated: true
                )
            }
        }
    }
}

// MARK: - TextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            loginButtonPressed()
        }
        return true
    }
}
