//
//  Country.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 08.12.2021.
//

import Foundation

struct Country: Codable {
    
    let iso: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso = "iso_3166_1"
        case name
    }
    
}
