//
//  CustomCell.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import UIKit

class CustomCell: UIView {
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "denee"
        return label
    }()
    let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .orange
        addSubViews(views: title, stepper)
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            stepper.topAnchor.constraint(equalTo: title.bottomAnchor),
            stepper.rightAnchor.constraint(equalTo: rightAnchor),
            heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
