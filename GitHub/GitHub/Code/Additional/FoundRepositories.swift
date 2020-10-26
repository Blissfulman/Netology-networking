//
//  Repository.swift
//  GitHub
//
//  Created by User on 18.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation
import UIKit

struct FoundRepositories: Codable {
    
    var count = 0
    var repositories = [Repository]()
        
    private enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case repositories = "items"
    }
    
    static func createFromJSON(_ json: String) -> FoundRepositories {
        
        guard let jsonData = json.data(using: .utf8) else {
            return FoundRepositories()
        }
        
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(FoundRepositories.self, from: jsonData) else {
            return FoundRepositories()
        }

        return result
    }
}

struct Repository: Codable {
    var name: String
    var description: String?
    var url: String
    var owner: Owner
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case url = "html_url"
        case owner
    }
    
    struct Owner: Codable {
        var login: String
        var avatarURL: String
        
        private enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }
}
