//
//  CustomTextField.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import UIKit

final class CustomTextField: UITextField {

    let padding: CGFloat
    let height: CGFloat
    var placeholderColor: UIColor = UIColor(white: 1, alpha: 0.6) {
        didSet {
            attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "" , attributes: [.foregroundColor: placeholderColor])
        }
    }
    
    
    init(padding: CGFloat, height: CGFloat, isSecure: Bool = false) {
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        textColor = .white
        tintColor = UIColor(white: 1, alpha: 0.6)
        layer.cornerRadius = height / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        //isSecureTextEntry = isSecure
    }
    
    override func didMoveToSuperview() {
        attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "" , attributes: [.foregroundColor: placeholderColor])
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

