//
//  BehaviorRelay+Extensions.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 18.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

extension BehaviorRelay {
    func addElement<T>(element: T) where Element == [T] {
        accept(value + [element])
    }
}

