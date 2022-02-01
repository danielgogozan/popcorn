//
//  Language.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 08.12.2021.
//

import Foundation

struct Language: Codable {
    let iso: String
    let name: String
    let englishName: String
    
    enum CodingKeys: String, CodingKey {
        case iso = "iso_639_1"
        case name
        case englishName = "english_name"
    }
    
}
