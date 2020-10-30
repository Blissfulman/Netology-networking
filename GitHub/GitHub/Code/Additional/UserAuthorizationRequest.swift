//
//  Authorization.swift
//  GitHub
//
//  Created by User on 28.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

struct UserAuthorizationRequest {
    
    /// Запрос авторизации пользователя.
    static func start(username: String,
                      password: String,
                      completion: @escaping (Int, String) -> Void) {
        
        let stringURL = "https://api.github.com/user"
                
        let loginString = String(format: "%@:%@", username, password)
        guard let dataLoginString = loginString.data(using: .utf8) else { return }
        let base64LoginString = dataLoginString.base64EncodedString()
        
        guard let url = URL(string: stringURL) else { return }
        
        var request = URLRequest(url: url)

        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
                        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            var statusCode = 0
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("http status code: \(httpResponse.statusCode)")
                statusCode = httpResponse.statusCode
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            guard let jsonData = String(data: data, encoding: .utf8) else {
                print("Data encoding failed")
                return
            }
                        
            completion(statusCode, jsonData)
        }.resume()
    }
}
