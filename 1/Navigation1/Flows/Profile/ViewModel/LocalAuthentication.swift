//
//  LocalAuthentication.swift
//  Navigation1
//
//  Created by Елена Хайрова on 01.06.2025.
//

import LocalAuthentication

enum BiometryType {
    case none
    case touchID
    case faceID
}

enum AuthorizationError: Error {
    case biometryNotAvailable
    case biometryLockout
    case biometryNotEnrolled
    case userCancel
    case systemCancel
    case other(Error)
    
    var localizedDescription: String {
        switch self {
        case .biometryNotAvailable: return NSLocalizedString("biometryNotAvailable", comment: "")
        case .biometryLockout: return NSLocalizedString("biometryLockout", comment: "")
        case .biometryNotEnrolled: return NSLocalizedString("biometryNotEnrolled", comment: "")
        case .userCancel: return NSLocalizedString("userCancel", comment: "")
        case .systemCancel: return NSLocalizedString("systemCancel", comment: "")
        case .other(let error): return error.localizedDescription
        }
    }
}

class LocalAuthorizationService {
    var availableBiometryType: BiometryType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none: return .none
            case .touchID: return .touchID
            case .faceID: return .faceID
            @unknown default: return .none
            }
        } else {
            return .touchID
        }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, AuthorizationError?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            let authError: AuthorizationError
            
            if let laError = error as? LAError {
                switch laError.code {
                case .biometryLockout: authError = .biometryLockout
                case .biometryNotEnrolled: authError = .biometryNotEnrolled
                case .biometryNotAvailable: authError = .biometryNotAvailable
                default: authError = .other(laError)
                }
            } else {
                authError = .biometryNotAvailable
            }
            
            DispatchQueue.main.async {
                authorizationFinished(false, authError)
            }
            return
        }
        
        let reason = NSLocalizedString("auth.prompt", comment: "")
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    authorizationFinished(true, nil)
                } else {
                    let authError: AuthorizationError
                    
                    if let laError = error as? LAError {
                        switch laError.code {
                        case .userCancel: authError = .userCancel
                        case .systemCancel: authError = .systemCancel
                        default: authError = .other(laError)
                        }
                    } else if let error = error {
                        authError = .other(error)
                    } else {
                        authError = .other(NSError(domain: "", code: -1, userInfo: nil))
                    }
                    
                    authorizationFinished(false, authError)
                }
            }
        }
    }
}
