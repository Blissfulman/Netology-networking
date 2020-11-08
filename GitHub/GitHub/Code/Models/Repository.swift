//
//  Repository.swift
//  GitHub
//
//  Created by User on 28.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

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
        var avatarUrl: String
        
        private enum CodingKeys: String, CodingKey {
            case login
            case avatarUrl = "avatar_url"
        }
    }
}
