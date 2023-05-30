//
//  UIViewController+ext.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 28.05.2023.
//

import UIKit

extension UIViewController {
    func setupRootViewController(viewController: UIViewController) {
        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
