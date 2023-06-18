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
    
    var databaseService: FirebaseDataBaseService?
    
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
                guard let userId = user?.id else {return}
                self?.databaseService?.addDocument(collectionPath: Collections.users, data: CellarUser(id: userId, name: self?.name, cellarsIDs: nil, userEmail: email, lastUpdate: Date.now),completion: { result in
                    switch result {
                    case .success(let success):
                        strongSelf.delegate?.handleViewModelOutput(.showLoading(false, ""))
                        strongSelf.delegate?.handleViewModelOutput(.userRegistered(true, ""))
                    case .failure(let failure):
                        strongSelf.delegate?.handleViewModelOutput(.userRegistered(false, failure.localizedDescription))
                    }
                })

            case .failure(let failure):
                strongSelf.delegate?.handleViewModelOutput(.userRegistered(false, failure.localizedDescription))
            }
        })
    }
}
