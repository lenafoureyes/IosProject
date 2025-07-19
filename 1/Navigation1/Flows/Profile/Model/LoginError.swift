//
//  LoginError.swift
//  Navigation1
//
//  Created by Елена Хайрова on 18.07.2025.
//

import UIKit

enum LoginError: Error {
    case emptyCredentials
    case invalidLogin
    case wrongPassword
    case credentialsMismatch
    case accountLocked
    case tooManyAttempts
    
    var localizedDescription: String {
        switch self {
        case .emptyCredentials:
            return NSLocalizedString("error.emptyCredentials", comment: "Please enter login and password")
        case .invalidLogin:
            return NSLocalizedString("error.invalidLogin", comment: "Invalid login")
        case .wrongPassword:
            return NSLocalizedString("error.wrongPassword", comment: "Wrong password")
        case .credentialsMismatch:
            return NSLocalizedString("error.credentialsMismatch", comment: "Login and password don't match")
        case .accountLocked:
            return NSLocalizedString("error.accountLocked", comment: "Account temporarily locked")
        case .tooManyAttempts:
            return NSLocalizedString("error.tooManyAttempts", comment: "Too many attempts. Try again later")
        }
    }
}
