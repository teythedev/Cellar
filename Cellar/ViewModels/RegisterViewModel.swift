//
//  RegisterViewModel.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation
final class RegisterViewModel: RegisteViewModelProtocol {
    var delegate: RegisterViewModelDelegate?
    
    var isFormValid: Bindable<Bool> = Bindable<Bool>()
    
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var password: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var name: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    var surname: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    
    private func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false && name?.isEmpty == false && surname?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performRegister() {
        Temps.isLoggedIn = true
        delegate?.handleViewModelOutput(.userRegistered(true))
    }
    
}
