//
//  Helpers.swift
//  Cellar
//
//  Created by Tugay Emre Yucedag on 21.05.2023.
//

import UIKit

final class Colors {
    static let redColor : UIColor = #colorLiteral(red: 0.4963988662, green: 0.1579049826, blue: 0.1714705229, alpha: 1)
    static let greenColor : UIColor = #colorLiteral(red: 0, green: 0.4823529412, blue: 0.1725490196, alpha: 1)
}

enum UnitType: String, CaseIterable , Codable{
    case KG, LT, PCS
    
    func getIndexOfUnitType()-> Int {
        switch self {
        case .KG:
            return 0
        case .LT:
            return 1
        case .PCS:
            return 2
        }
    }
}




