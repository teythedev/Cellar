//
//  RegisterViewModel.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation
import FirebaseAuth
final class RegisterViewModel: RegisteViewModelProtocol {
    var delegate: RegisterViewModelDelegate?
    
    var authService: AuthServiceProtocol?
    
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
        guard let email = email, let password = password  else { return }
        delegate?.handleViewModelOutput(.showLoading(true, "Registering"))
        authService?.registerWith(email: email, password: password, completion: { [ weak self ] result in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let user):
                let user = user as? User
                strongSelf.delegate?.handleViewModelOutput(.showLoading(false, ""))
                strongSelf.delegate?.handleViewModelOutput(.userRegistered(true, ""))
            case .failure(let failure):
                strongSelf.delegate?.handleViewModelOutput(.userRegistered(false, failure.localizedDescription))
            }
        })
    }
}
