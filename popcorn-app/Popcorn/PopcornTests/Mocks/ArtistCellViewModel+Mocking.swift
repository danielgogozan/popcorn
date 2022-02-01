//
//  ArtistCellViewModel+Mocks.swift
//  PopcornTests
//
//  Created by Daniel Gogozan on 07.12.2021.
//

import Foundation
@testable import Popcorn

extension ArtistCellViewModel: Equatable {
    public static func == (lhs: ArtistCellViewModel, rhs: ArtistCellViewModel) -> Bool {
        lhs.artist.value == rhs.artist.value
    }
}
