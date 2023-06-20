//
//  UserManager.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 19.06.2023.
//

import Foundation


class CellarUserManager {
    private var cellarUserInstance: CellarUser?
    
    static let shared = CellarUserManager()
    
    private init() {}
    
    
    func setCellarUser(cellarUser: CellarUser) throws {
        if cellarUserInstance != nil
        {
            self.cellarUserInstance = cellarUser
        }else {
            throw NSError(domain: "Cellar user already present", code: 0)
        }
    }
    
    func disposeCellarUser() {
        cellarUserInstance = nil
    }
    
    var cellarUser: CellarUser? {
        get {
            cellarUserInstance
        }
    }
}
