//
//  CustomCell.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import UIKit

protocol CustomCellDelegate {
    func productChanged(at: CustomCell,product: Product)
    func proddd(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
}

final class CustomCell: UITableViewCell {
    static let cellIdentifier = "CustomCellIdentifier"
    
    var product: Product? {
        didSet {
            titleTextField.text = product?.name ?? ""
            amountLabel.text = product?.amount ?? ""
            stepper.value = Double(product?.amount ?? "0.0")!
        }
    }
    
    var delegate: CustomCellDelegate?
    
    private var isInEditingMode = false
    
    let titleTextField: UITextField = {
        let texfield = UITextField()
        texfield.placeholder = "Enter product name"
        texfield.translatesAutoresizingMaskIntoConstraints = false
        texfield.isUserInteractionEnabled = false
        texfield.addTarget(self, action: #selector(titleTextChanged), for: .editingChanged)
        texfield.clearButtonMode = .whileEditing
        return texfield
    }()
    
    let amountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    let amountLabel: UILabel = {
        let texfield = UILabel()
        texfield.text = "0"
        texfield.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return texfield
    }()
    
    let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0

        stepper.stepValue = 0.1
        stepper.autorepeat = true
        stepper.isHidden = true
        stepper.isUserInteractionEnabled = false
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        return stepper
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "lock"), for: .normal)
        button.imageView?.tintColor = .red
        button.addTarget(self, action: #selector(editingModeChanged), for: .touchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        createView()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView() {
        layer.borderColor = UIColor.orange.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 8
        
        amountStackView.addArrangedSubview(amountLabel)
        amountStackView.addArrangedSubview(stepper)
        
        addSubViews(views: amountStackView, titleTextField, saveButton)
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant:  16),
            saveButton.topAnchor.constraint(equalTo: topAnchor),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 26),
            titleTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55),
            titleTextField.topAnchor.constraint(equalTo: topAnchor),
            titleTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            amountStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            amountStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.20),
            amountStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            amountStackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8),
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 80)
    }
    
    @objc private func editingModeChanged(){
        isInEditingMode = !isInEditingMode
        saveButton.setImage(UIImage(systemName: isInEditingMode ? "lock.open" : "lock"), for: .normal)
        saveButton.imageView?.tintColor =  isInEditingMode ? .green : .red
        titleTextField.isUserInteractionEnabled = isInEditingMode
       
        stepper.isUserInteractionEnabled = isInEditingMode
        stepper.isHidden = !isInEditingMode
        if(isInEditingMode == false) {
            guard let product = product, let delegate = delegate else {return}
            delegate.productChanged(at: self, product: product)
            //delegate.proddd(, heightForRowAt: <#T##IndexPath#>)
        }
    }
    
    @objc private func stepperValueChanged(sender: UIStepper) {
        amountLabel.text = String(format: "%.1f",sender.value)
        product?.amount = String(format: "%.1f",sender.value)
        
    }
    
    @objc private func titleTextChanged(sender: UITextField) {
        if sender == titleTextField {
            titleTextField.text = sender.text ?? ""
            product?.name = titleTextField.text!
        }
        
    }
    
    override func prepareForReuse() {
        product = nil
    }
}



