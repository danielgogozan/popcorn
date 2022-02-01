////
////  AppFonts.swift
////  Popcorn
////
////  Created by Daniel Gogozan on 17.11.2021.
////
//
//import UIKit
//
//
//struct AppFonts {
//
//    static func lato(size: CGFloat) -> UIFont {
//        return loadFont(fontName: "Lato", size: size)
//    }
//
//    static func latoRegular(size: CGFloat) -> UIFont {
//        return loadFont(fontName: "Lato-Regular", size: size)
//    }
//
//    static func appleGothic(size: CGFloat) -> UIFont {
//        return loadFont(fontName: "AppleGothic", size: size)
//    }
//    
//    static func loadFont(fontName: String, size: CGFloat) -> UIFont {
//        guard let font = UIFont(name: fontName, size: size) else {
//            return UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: size)
//        }
//        return font
//    }
//
//}
