//
//  Repository.swift
//  GitHub
//
//  Created by Evgeny Novgorodov on 18.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

struct FoundRepositories: Decodable {
    
    let count: Int
    let repositories: [Repository]
        
    private enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case repositories = "items"
    }
    
    static func createFromJSON(_ jsonData: Data) -> FoundRepositories? {
        
        guard let result = try? JSONDecoder().decode(FoundRepositories.self, from: jsonData) else {
            return nil
        }

        return result
    }
}
