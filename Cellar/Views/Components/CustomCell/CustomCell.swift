//
//  CustomCell.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import UIKit

protocol CustomCellDelegate {
    func onEditingEnd(cell: CustomCell,product: Product)
    func productDeleted(cell: CustomCell,product: Product)
    func showWarning(error: CustomCellError, handler: @escaping ((Bool) -> Void))
}



public enum CustomCellError{
    case NoTitle(String)
    case ZeroAmount(String)
}

final class CustomCell: UITableViewCell {
    static let cellIdentifier = "CustomCellIdentifier"
    
    
    
    var product: Product? {
        didSet {
            titleTextField.text = product?.name ?? ""
            amountLabel.text = "\(product?.amount ?? "") \(product?.unitType.rawValue ?? "N/A")"
            stepper.value = Double(product?.amount ?? "0.0")!
            stepper.stepValue = product?.unitType == .PCS ? 1 : 0.1
            segmentedControl.selectedSegmentIndex = product?.unitType.getIndexOfUnitType() ?? 0
        }
    }
    
    private var contanierView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    var delegate: CustomCellDelegate?
    
    private var isInEditingMode = false {
        didSet {
            saveButton.setImage(UIImage(systemName: isInEditingMode ? "lock.open" : "lock"), for: .normal)
            saveButton.imageView?.tintColor =  isInEditingMode ? Colors.greenColor : Colors.redColor
            titleTextField.isUserInteractionEnabled = isInEditingMode
            stepper.isUserInteractionEnabled = isInEditingMode
            stepper.isHidden = !isInEditingMode
            segmentedControl.isUserInteractionEnabled = isInEditingMode
            segmentedControl.isEnabled = isInEditingMode
            deleteButton.isHidden = !isInEditingMode
        }
    }
    
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
        stackView.alignment = .trailing
        stackView.spacing = 8
        return stackView
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
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
        button.imageView?.tintColor = Colors.redColor
        button.addTarget(self, action: #selector(editingModeChanged), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.imageView?.tintColor = .red
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let segmentedControl : UISegmentedControl = {
        let segment = UISegmentedControl(items: UnitType.allCases.map{"\($0)"})
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.isEnabled = false
        segment.isUserInteractionEnabled = false
        segment.addTarget(self, action: #selector(onSegmentControlValueChanged), for: .valueChanged)
        return segment
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
        addSubview(contanierView)
        amountStackView.addArrangedSubview(amountLabel)
        amountStackView.addArrangedSubview(stepper)
        contanierView.addSubViews(views: amountStackView, titleTextField, saveButton,deleteButton,segmentedControl)
        addConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 80)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        product = nil
        isInEditingMode = false
    }
}

// MARK: - Constraints
extension CustomCell {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            contanierView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contanierView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contanierView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            contanierView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            saveButton.leadingAnchor.constraint(equalTo: contanierView.leadingAnchor, constant:  32),
            saveButton.topAnchor.constraint(equalTo: contanierView.topAnchor),
            saveButton.widthAnchor.constraint(equalTo: contanierView.widthAnchor, multiplier: 0.05),
            saveButton.bottomAnchor.constraint(equalTo: contanierView.bottomAnchor),
            
            titleTextField.leadingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 26),
            titleTextField.widthAnchor.constraint(equalTo: contanierView.widthAnchor, multiplier: 0.45),
            titleTextField.topAnchor.constraint(equalTo: contanierView.topAnchor),
            
            segmentedControl.heightAnchor.constraint(equalToConstant: 16),
            segmentedControl.widthAnchor.constraint(equalTo: contanierView.widthAnchor, multiplier: 0.30),
            segmentedControl.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: contanierView.bottomAnchor, constant: -6),
            segmentedControl.leadingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 26),
            
            amountStackView.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -24),
            amountStackView.widthAnchor.constraint(equalTo: contanierView.widthAnchor, multiplier: 0.20),
            amountStackView.topAnchor.constraint(equalTo: contanierView.topAnchor, constant: 8),
            amountStackView.bottomAnchor.constraint(equalTo: contanierView.bottomAnchor,constant: -8),
            
            deleteButton.topAnchor.constraint(equalTo: contanierView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contanierView.trailingAnchor, constant:  -16),
            deleteButton.bottomAnchor.constraint(equalTo: contanierView.bottomAnchor)
        ])
    }
}

// MARK: - Targets
extension CustomCell {
    @objc private func editingModeChanged(){
        isInEditingMode = !isInEditingMode
        if(!isInEditingMode) {
            if let text = titleTextField.text, text.isEmpty {
                
                delegate?.showWarning(error: .NoTitle("Please delete product or enter product name!"), handler: { result in
                    
                })
                titleTextField.becomeFirstResponder()
                isInEditingMode = !isInEditingMode
            }else {
                
                endEditing(true)
                guard let product = product, let delegate = delegate else {return}
                delegate.onEditingEnd(cell: self, product: product)
            }
            
        }
    }
    
    @objc private func stepperValueChanged(sender: UIStepper) {
        if sender.value.isZero {
            delegate?.showWarning(error: .ZeroAmount("Current amount is 0 this product will be deleted!"), handler: {[weak self] result in
                if result {
                    guard let storngSelf = self else {return}
                    guard let product = storngSelf.product else {return}
                    storngSelf.delegate?.productDeleted(cell: storngSelf, product: product)
                }
            })
            
        }else {
            amountLabel.text = String(format: "%.1f",sender.value)
            product?.amount = String(format: "%.1f",sender.value)
        }
    }
    
    @objc private func titleTextChanged(sender: UITextField) {
        if let title = sender.text, !title.isEmpty {
            titleTextField.text = title
            product?.name = title
        } else {
            delegate?.showWarning(error: .NoTitle("Please enter product name, unless you will be delete it"), handler: { result in
                print(self.product?.name)
            })
        }
    }
    
    @objc private func deleteButtonTapped() {
        if let product = product {
            delegate?.productDeleted(cell: self, product: product)
        }
    }
    
    @objc private func onSegmentControlValueChanged(sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        guard let selectedUnitTypeString = sender.titleForSegment(at: selectedIndex) else {return}
        product?.unitType = UnitType(rawValue: selectedUnitTypeString)!
        switch product?.unitType {
        case .PCS:
            stepper.stepValue = 1.0
        default:
            stepper.stepValue = 0.1
        }
    }
}



