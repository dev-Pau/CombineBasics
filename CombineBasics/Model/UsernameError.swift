//
//  UsernameError.swift
//  CombineBasics
//
//  Created by PdePau on 7/8/24.
//

import Foundation

enum UsernameError: Error, LocalizedError {
    case length
    
    var errorDescription: String? {
        switch self {
        case .length:
            return "The username is too short."
        }
    }
}
