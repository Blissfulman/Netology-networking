//
//  AuthenticationManager.swift
//  GitHub
//
//  Created by User on 14.11.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import LocalAuthentication

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
        
    private init() {}
    
    func authenticateUser(username: String,
                          password: String,
                          completion: @escaping () -> Void) {
        
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
            ) { success, evaluateError in
                if success {
                    // Пользователь успешно прошел аутентификацию
                    completion()
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
