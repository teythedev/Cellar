//
//  LoginViewModel.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation
final class LoginViewModel: LoginViewModelProtocol {
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
    
    var isFormValid: Bindable<Bool> = Bindable<Bool>()
    
    var delegate: LoginViewModelDelegate?
    
    private func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performLogin() {
        Temps.isLoggedIn = true
        delegate?.handleViewModelOutput(.userLoggedIn(true))
    }
}
