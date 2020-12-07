//
//  User.swift
//  GitHub
//
//  Created by User on 28.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    let login: String
    let avatarUrl: String
    
    static func createFromJSON(_ jsonData: Data) -> User? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let user = try? decoder.decode(User.self, from: jsonData) else {
            return nil
        }

        return user
    }
}
