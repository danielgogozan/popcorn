//
//  DateUtils.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 13.12.2021.
//

import Foundation

class DateUtils {
    
    static func defaultDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter
    }
    
}
