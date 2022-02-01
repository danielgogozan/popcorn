//
//  UIViewController+Extensions.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import UIKit

extension UIViewController {
    
    func addSubviews(views: [UIView]) {
        views.forEach { self.view.addSubview($0) }
    }

    func setStatusBar(color: UIColor) {
        if #available(iOS 13, *)
        {
            let statusBar = UIView(frame: (self.view?.window?.windowScene?.statusBarManager?.statusBarFrame) ?? CGRect.zero)
            statusBar.backgroundColor = color
            let keyWindow = keyWindow()
            keyWindow?.addSubview(statusBar)
        }
    }
    
    func keyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
    }
    
    func configureWithTransparentNavBar() {
        navigationController?.navigationBar.tintColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationItem.compactAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.standardAppearance = appearance
    }
    
}
