//
//  LoginViewModel.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation
import FirebaseAuth

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
    
    var authService: AuthServiceProtocol?
    
    private func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performLogin() {
        guard let email = email, let password = password else {return}
        delegate?.handleViewModelOutput(.showLoading(true, "Logging in"))
        authService?.loginWith(email: email, password: password, completion: { [ weak self ] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let user):
                let defaults = UserDefaults.standard
                defaults.setValue(user?.id, forKey: "currentUserID")
                strongSelf.delegate?.handleViewModelOutput(.showLoading(false, ""))
                strongSelf.delegate?.handleViewModelOutput(.userLoggedIn(true,""))
            case .failure(let failure):
                strongSelf.delegate?.handleViewModelOutput(.userLoggedIn(false, failure.localizedDescription))
            }
        })
    }
}
