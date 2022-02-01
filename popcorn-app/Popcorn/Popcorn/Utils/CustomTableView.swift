//
//  CustomTableView.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 24.11.2021.
//

import UIKit

class CustomTableView: UITableView {
    override func layoutSubviews() {
        if (self.window == nil) {
            return
        }
        super.layoutSubviews()
    }
}
