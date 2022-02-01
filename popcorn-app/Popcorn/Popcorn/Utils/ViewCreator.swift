//
//  ViewCreator.swift
//  Popcorn
//
//  Created by Daniel Gogozan on 17.11.2021.
//

import UIKit

struct ViewCreator {
 
    static func createImageView(contentMode: UIView.ContentMode, image: UIImage? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = contentMode
        imageView.image = image
        return imageView
    }
    
    static func createCircularImageView(contentMode: UIView.ContentMode, image: UIImage? = nil) -> CircularImageView {
        let imageView = CircularImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = contentMode
        imageView.image = image
        return imageView
    }
    
    static func createLabel(text: String, font: UIFont, numberOfLines: Int = 1, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = font
        label.numberOfLines = numberOfLines
        label.textColor = textColor
        return label
    }
    
    static func createStackView(subviews: [UIView] = [], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        return stackView
    }
    
    static func createButton(title: String, font: UIFont, numberOfLines: Int = 1, titleColor: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        return button
    }
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }
    
    static func presentAlertMessage(viewController: UIViewController, title: String, message: String, actions: [UIAlertAction]) {
        let alertTitle = NSLocalizedString(title, comment: "alert title")
        let alertMessage = NSLocalizedString(message, comment: "alert message")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        viewController.present(alert, animated: true)
    }
}
