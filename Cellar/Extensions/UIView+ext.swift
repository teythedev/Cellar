//
//  UIView+ext.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import UIKit

extension UIView {
    func addSubViews(views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
