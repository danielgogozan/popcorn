//
//  GenreCellViewModel+Mocks.swift
//  PopcornTests
//
//  Created by Daniel Gogozan on 07.12.2021.
//

import Foundation
@testable import Popcorn

extension GenreCellViewModel: Equatable {
    public static func == (lhs: GenreCellViewModel, rhs: GenreCellViewModel) -> Bool {
        lhs.genre.value == rhs.genre.value
    }
}
