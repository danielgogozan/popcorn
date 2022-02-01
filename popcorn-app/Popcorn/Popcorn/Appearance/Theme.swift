//
//  Theme.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import UIKit

struct Theme {
    
    static func customize() {
        customizeNavBar()
        customizeTabBar()
    }
    
    private static func customizeNavBar() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Asset.Colors.black.color,
                                                            NSAttributedString.Key.font: FontFamily.AppleGothic.regular.font(size: 17)]
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Asset.Colors.black.color,
                                              NSAttributedString.Key.font: FontFamily.AppleGothic.regular.font(size: 17)]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private static func customizeTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: FontFamily.Lato.regular.font(size: 10)], for: .normal)
    }
    
}
