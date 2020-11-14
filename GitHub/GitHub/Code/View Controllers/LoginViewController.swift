//
//  ViewController.swift
//  GitHub
//
//  Created by User on 11.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit
import Kingfisher
import LocalAuthentication

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
    
    private let logoURL = "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png"
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupUI()
        setupLayout()
        loginButton.addTarget(self,
                              action: #selector(loginButtonPressed),
                              for: .touchUpInside)
        
        if let keychainData = KeychainManager.getKeychainData() {
            authorizeUser(username: keychainData.username,
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
        
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        authorizeUser(username: username, password: password)
    }
            
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        
        let url = URL(string: logoURL)
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
        
        RequestManager.userAuthorization(username: username,
                                         password: password) {
            [weak self] (statusCode, jsonData) in
            
            guard let `self` = self else { return }
            
            guard statusCode == 200 else {
                print("Error authorization")
                return
            }
            
            KeychainManager.savePassword(account: username, password: password)
            
            guard let user = User.createFromJSON(jsonData) else { return }
            
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

// MARK: - TouchID/FaceID authentication
extension LoginViewController {
    
    private func authenticateUser(username: String, password: String) {
        
        guard #available(iOS 8.0, *, *) else {
            print("Версия iOS не поддерживает TouchID")
            return
        }
        
        let authenticationContext = LAContext()
        setupAuthenticationContext(context: authenticationContext)
        
        let reason = "Fast and safe authentication in your app"
        var authError: NSError?
        
        if authenticationContext.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics, error: &authError
        ) {
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) { [unowned self] success, evaluateError in
                if success {
                    // Пользователь успешно прошел аутентификацию
                    authorizeUser(username: username, password: password)
                } else {
                    // Пользователь не прошел аутентификацию
                    if let error = evaluateError {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            // Не удалось выполнить проверку на использование биометрических данных или пароля для аутентификации
            if let error = authError {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupAuthenticationContext(context: LAContext) {
        context.localizedReason = "Use for fast and safe authentication in your app"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Enter password"
        
        context.touchIDAuthenticationAllowableReuseDuration = 600
    }
}
