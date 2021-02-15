//
//  Repository.swift
//  GitHub
//
//  Created by Evgeny Novgorodov on 28.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

struct Repository: Decodable {
    
    let name: String
    let description: String?
    let url: String
    let owner: Owner
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case url = "html_url"
        case owner
    }
}

struct Owner: Decodable {
    let login: String
    let avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
