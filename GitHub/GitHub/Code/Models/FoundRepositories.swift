//
//  Repository.swift
//  GitHub
//
//  Created by User on 18.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import Foundation

struct FoundRepositories: Codable {
    
    var count = 0
    var repositories = [Repository]()
        
    private enum CodingKeys: String, CodingKey {
        case count = "total_count"
        case repositories = "items"
    }
    
    static func createFromJSON(_ json: String) -> FoundRepositories? {
        
        guard let jsonData = json.data(using: .utf8) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(FoundRepositories.self,
                                               from: jsonData) else {
            return nil
        }

        return result
    }
}
