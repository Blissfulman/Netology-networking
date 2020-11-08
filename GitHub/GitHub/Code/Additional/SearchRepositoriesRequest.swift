//
//  SearchRepository.swift
//  GitHub
//
//  Created by User on 17.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

struct SearchRepositoriesRequest {

    let scheme = "https"
    let host = "api.github.com"
    let searchRepoPath = "/search/repositories"
    
    let defaultHeaders = ["Content-Type" : "application/json",
                          "Accept" : "application/vnd.github.v3+json"]
        
    /// Поиск репозиториев с переданными параметрами.
    func start(name repositoryName: String,
               language: String,
               order: String,
               completion: @escaping (Data) -> Void) {
        
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
}

extension SearchRepositoriesRequest {
    
    private func getURL(repositoryName: String,
                        language: String,
                        order: String) -> URL? {
        
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
