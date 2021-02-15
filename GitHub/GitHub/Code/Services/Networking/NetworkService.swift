//
//  RequestManager.swift
//  GitHub
//
//  Created by Evgeny Novgorodov on 14.11.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

typealias LoginResult = (User?) -> Void
typealias SearchResult = (FoundRepositories) -> Void

protocol NetworkServiceProtocol {
    func userLogin(username: String, password: String, completion: @escaping LoginResult)
    
    func search(name repositoryName: String,
                language: String,
                order: String,
                completion: @escaping SearchResult)
}

final class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Авторизация пользователя.
    func userLogin(username: String, password: String, completion: @escaping LoginResult) {
                
        let base64LoginString = password.data(using: .utf8)?.base64EncodedString() ?? ""
        
        guard let url = URL(string: URLs.login) else { return }
        
        var request = URLRequest(url: url)

        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data, response, error) in
                        
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let data = data,
                      let response = response as? HTTPURLResponse {
                print("http status code: \(response.statusCode)")
                
                if response.statusCode != 200 {
                    print("Error authorization")
                    completion(nil)
                    return
                }
                
                KeychainStorage().savePassword(account: username, password: password)
                    ? print("Password saved")
                    : print("Password saving error")
                
                guard let user = User.createFromJSON(data) else { return }
                
                completion(user)
            }
        }.resume()
    }
    
    /// Поиск репозиториев с переданными параметрами.
    func search(name repositoryName: String,
                language: String,
                order: String,
                completion: @escaping SearchResult) {
        
        let defaultHeaders = ["Content-Type": "application/json",
                              "Accept": "application/vnd.github.v3+json"]
        
        guard let url = getSearchURL(repositoryName: repositoryName,
                                     language: language,
                                     order: order) else { return }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        
        session.dataTask(with: request) { data, response, error in
            
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
            
            guard let foundRepositories =
                FoundRepositories.createFromJSON(jsonData) else { return }
            
            completion(foundRepositories)
        }.resume()
    }
    
    private func getSearchURL(repositoryName: String, language: String, order: String) -> URL? {
        
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
