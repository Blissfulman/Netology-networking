//
//  RequestManager.swift
//  GitHub
//
//  Created by User on 14.11.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

struct RequestManager {
    
    /// Запрос авторизации пользователя.
    static func userAuthorization(username: String,
                                  password: String,
                                  completion: @escaping (Int, Data) -> Void) {
        print(username, password)
        let stringURL = "https://api.github.com/user"
                
        let loginString = String(format: "%@:%@", username, password)
        guard let dataLoginString = loginString.data(using: .utf8) else { return }
        let base64LoginString = dataLoginString.base64EncodedString()
        
        guard let url = URL(string: stringURL) else { return }
        
        var request = URLRequest(url: url)

        request.setValue("Basic \(base64LoginString)",
                         forHTTPHeaderField: "Authorization")
        
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
            
            guard let jsonData = data else {
                print("No data received")
                return
            }
            
            completion(statusCode, jsonData)
        }.resume()
    }
    
    /// Поиск репозиториев с переданными параметрами.
    static func searchRepositories(name repositoryName: String,
                                   language: String,
                                   order: String,
                                   completion: @escaping (Data) -> Void) {
        
        let defaultHeaders = ["Content-Type" : "application/json",
                              "Accept" : "application/vnd.github.v3+json"]
        
        guard let url = getURL(repositoryName: repositoryName,
                               language: language,
                               order: order) else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("http status code: \(httpResponse.statusCode)")
            }
            
            guard let jsonData = data else {
                print("No data received")
                return
            }
            
            completion(jsonData)
        }.resume()
    }
    
    static func getURL(repositoryName: String,
                       language: String,
                       order: String) -> URL? {
        
        let scheme = "https"
        let host = "api.github.com"
        let searchRepoPath = "/search/repositories"
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = searchRepoPath
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "\(repositoryName)+language:\(language)"),
            URLQueryItem(name: "order", value: "\(order)"),
            URLQueryItem(name: "per_page", value: "100")
        ]
        
        guard let url = urlComponents.url else { return nil }
        print("Search request url: \(url)")
        return url
    }
}
