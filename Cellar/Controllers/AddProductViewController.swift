//
//  AddProductView.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 18.06.2023.
//
import UIKit

class AddProductViewController: UIViewController {
    
    private let nameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 8, height: 65)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter Name"
        //tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    
    private let amountTextField: CustomTextField = {
        let tf = CustomTextField(padding: 8, height: 65)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter Amount"
        tf.keyboardType = .decimalPad
        //tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let unitTypeSegmentedControl : UISegmentedControl = {
        let segment = UISegmentedControl(items: UnitType.allCases.map{"\($0)"})
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.isEnabled = false
        segment.isUserInteractionEnabled = false
        //segment.addTarget(self, action: #selector(onSegmentControlValueChanged), for: .valueChanged)
        return segment
    }()
    
    override func viewDidLoad() {
        view.addSubViews(views: nameTextField,amountTextField, unitTypeSegmentedControl)
    }
}
