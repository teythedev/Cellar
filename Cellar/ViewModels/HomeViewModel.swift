//
//  HomeViewModel.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 10.05.2023.
//

import Foundation
final class HomeViewModel: HomeViewModelProtocol {
    func fetchCurrentUser(completion: @escaping (User?) -> ()) {
        if isUserLoggedIn {
            print("Current User is: Bla")
            completion(User(name: "Emre"))
        } else {
            print("User not logged In")
            completion(nil)
        }
    }
    

    
    var delegate: HomeViewModelDelegate?
    
    private var isUserLoggedIn = false
    

    
}
