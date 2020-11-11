//
//  Repository.swift
//  GitHub
//
//  Created by User on 18.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

struct FoundRepositories: Decodable {
    
    var count: Int
    var repositories: [Repository]
        
    private enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case repositories = "items"
    }
    
    init() {
        count = 0
        repositories = []
    }
    
    static func createFromJSON(_ jsonData: Data) -> FoundRepositories? {
        
        guard let result = try? JSONDecoder().decode(FoundRepositories.self,
                                                     from: jsonData) else {
            return nil
        }

        return result
    }
}
