//
//  SearchRepository.swift
//  GitHub
//
//  Created by User on 17.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

struct SearchRepository {
//    let token = "97cc2bcf3b07d9bc7dc27748985739d8b10016d5"
    let scheme = "https"
    let host = "api.github.com"
    let hostPath = "https://api.github.com"
    let searchRepoPath = "/search/repositories"
    
    let defaultHeaders = [
        "Content-Type" : "application/json",
        "Accept" : "application/vnd.github.v3+json"
    ]
    
    /// Поиск репозиториев с переданными параметрами.
    func searchRepositories(username: String,
                            repositoryName: String,
                            language: String,
                            order: String) {
        
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = searchRepoPath
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q",
                         value: "\(repositoryName)+user:\(username)+language:\(language)"),
            URLQueryItem(name: "order", value: "\(order)")
        ]
        
        guard let url = urlComponents.url else { return }
        
        print("Search request url: \(url)")
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        let sharedSession = URLSession.shared
                
        let dataTask = sharedSession.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("http status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            guard let text = String(data: data, encoding: .utf8) else {
                print("Data encoding failed")
                return
            }
            
            print("Received data:\n\(text)")
        }
        
        dataTask.resume()
    }
}
