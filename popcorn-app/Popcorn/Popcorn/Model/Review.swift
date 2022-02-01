//
//  Review.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 08.12.2021.
//

import Foundation

struct Review: Codable {
    let id: String
    let authorDetails: AuthorDetails
    let author: String
    let content: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorDetails = "author_details"
        case author
        case content
        case date = "created_at"
    }
    
    var prettyDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateStyle = .medium
        return  dateFormatter.string(from: date!)
    }
    
    var rating: Int {
        return Int((5 * (authorDetails.rating ?? 0)) / 10)
    }
}

struct Reviews: Codable {
    let results: [Review]
}

struct AuthorDetails: Codable {
    let name: String
    let avatarPath: String?
    let rating: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case avatarPath = "avatar_path"
        case rating
    }
    
    // avatarPath has a '/' char at the beginning of the url and it should be ignored. e.g: /https://secure.gravatar.com/avatar/dadb1b759a8516c815cdcc58abcefc85.jpg
    var formattedAvatarPath: String? {
        guard let avatarPath = avatarPath else {
            return nil
        }
        return avatarPath[1..<avatarPath.count]
    }
}

extension String {
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
