//
//  CustomCell.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import UIKit

class CustomCell: UIView {
    //static let cellIdentifier = "CustomCellIdentifier"
    
    private var isViewEnable = false
    
    let overAllStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    let titleTextField: UITextField = {
        let texfield = UITextField()
        texfield.placeholder = "Enter product name"
        texfield.isUserInteractionEnabled = false
        return texfield
    }()
    let amountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.autorepeat = true
        stepper.isUserInteractionEnabled = false
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView() {
        amountLabel.isUserInteractionEnabled = isViewEnable
        stepper.isUserInteractionEnabled = isViewEnable
        amountStackView.addArrangedSubview(amountLabel)
        amountStackView.addArrangedSubview(stepper)
        overAllStackView.addArrangedSubview(amountStackView)
        overAllStackView.addArrangedSubview(titleTextField)
        
        layer.borderColor = UIColor.orange.cgColor
        layer.borderWidth = 2
        addSubViews(views: overAllStackView)
        NSLayoutConstraint.activate([
            overAllStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            overAllStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            overAllStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            overAllStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longTapped)))
        
    }
    
    @objc private func longTapped(sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            print("View Long Tapped \(isViewEnable)")
            amountLabel.isUserInteractionEnabled = true
            stepper.isUserInteractionEnabled = true
        }

    }
    
    @objc private func stepperValueChanged(sender: UIStepper) {
        let stepperValue = sender.value
        amountLabel.text = String(stepperValue)
    }
}

