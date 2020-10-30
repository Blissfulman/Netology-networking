//
//  User.swift
//  GitHub
//
//  Created by User on 28.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let login: String
    let avatarURL: String
    
    private enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
    
    static func createFromJSON(_ json: String) -> User? {
        
        guard let jsonData = json.data(using: .utf8) else { return nil }
        
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(User.self, from: jsonData) else {
            return nil
        }

        return result
    }
}
