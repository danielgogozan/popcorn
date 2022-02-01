//
//  Dictionary+Plus.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 18.11.2021.
//

import Foundation

extension Dictionary where Key == MovieSection, Value == [MovieViewModel] {
    static func +(lhs: [MovieSection : [MovieViewModel]], rhs: [MovieSection : [MovieViewModel]]) -> [MovieSection : [MovieViewModel]] {
        return lhs.merging(rhs) { _, new in new }
    }
}
