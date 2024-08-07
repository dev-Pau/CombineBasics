//
//  PasswordError.swift
//  CombineBasics
//
//  Created by PdePau on 7/8/24.
//

import Foundation

enum PasswordError: Error, LocalizedError {
    case empty, match, weak
    
    var errorDescription: String? {
        switch self {
            
        case .empty:
            return "The password field is empty."
        case .match:
            return "The passwords do not match."
        case .weak:
            return "The password is too weak."
        }
    }
}
