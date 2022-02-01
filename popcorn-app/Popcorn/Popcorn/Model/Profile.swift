//
//  Profile.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 09.12.2021.
//

import Foundation

struct Profile: Codable {
    
    let aspectRatio: Float
    let height: Float
    let width: Float
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case width
        case filePath = "file_path"
    }
}

struct Profiles: Codable {
    let profiles: [Profile]
}
