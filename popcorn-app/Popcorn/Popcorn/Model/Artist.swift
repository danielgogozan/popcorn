//
//  Artist.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 26.11.2021.
//

import UIKit

struct Artist: Codable, Equatable {
 
    // other artist properties will be added when needed
    let id: Int
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case biography
        case placeOfBirth = "place_of_birth"
        case birthday
        case department = "known_for_department"
    }
    
    var poster: UIImage?
    
    var biography: String?
    var placeOfBirth: String?
    var birthday: String?
    var department: String?
    
    var departmentAndBirth: String {
        guard let department = department else {
            return prettyBirthDate
        }
        return department + " | " + prettyBirthDate
    }
    
    var prettyBirthDate: String {
        guard let birthday = birthday else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: birthday)
        dateFormatter.dateStyle = .medium
        return  dateFormatter.string(from: date!)
    }
}

struct Artists: Codable {
    let results: [Artist]
}
