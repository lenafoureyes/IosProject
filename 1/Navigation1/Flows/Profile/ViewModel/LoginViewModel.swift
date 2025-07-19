//
//  LoginViewModel.swift
//  Navigation1
//
//  Created by Елена Хайрова on 18.07.2025.
//

import UIKit

class LoginViewModel {
    private let loginDelegate: LoginViewControllerDelegate
    private let authService: LocalAuthorizationService
    
    var onLoginSuccess: ((User) -> Void)?
    var onLoginFailure: ((String) -> Void)?
    var onBiometryAvailable: ((UIButton.Configuration) -> Void)?
    
    init(loginDelegate: LoginViewControllerDelegate = LoginInspector(),
         authService: LocalAuthorizationService = LocalAuthorizationService()) {
        self.loginDelegate = loginDelegate
        self.authService = authService
    }
        
    func checkCredentials(login: String, password: String) {
        do {
            let success = try loginDelegate.check(login: login, password: password)
            
            if success {
                let testUserService = TestUserService()
                if let user = testUserService.getUser(byLogin: login) {
                    DispatchQueue.main.async {
                        self.onLoginSuccess?(user)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.onLoginFailure?(NSLocalizedString("login.error.userNotFound", comment: "user not found"))
                    }
                }
            }
        } catch let error as LoginError {
            DispatchQueue.main.async {
                self.handleLoginError(error)
                
                // Обработка блокировки кнопки при ошибках
                if error == .tooManyAttempts || error == .accountLocked {
                    self.onAccountLocked?()
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.onLoginFailure?(NSLocalizedString("login.error.unknown", comment: "An unknown error occurred"))
            }
        }
    }
        
        // Добавляем новый closure для обработки блокировки аккаунта
        var onAccountLocked: (() -> Void)?
        
        private func handleLoginError(_ error: LoginError) {
            onLoginFailure?(error.localizedDescription)
            
            if error == .tooManyAttempts || error == .accountLocked {
                onAccountLocked?()
                
                // Через 30 секунд разблокируем
                DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                    Checker.shared.resetAttempts()
                    self.onAccountUnlocked?()
                }
            }
        }
        
        var onAccountUnlocked: (() -> Void)?
    
    func configureBiometryButton() {
        var configuration = UIButton.Configuration.filled()
        
        switch authService.availableBiometryType {
        case .faceID:
            configuration.image = UIImage(systemName: "faceid")
            configuration.title = NSLocalizedString("face.id", comment: "")
        case .touchID:
            configuration.image = UIImage(systemName: "touchid")
            configuration.title = NSLocalizedString("touch.id", comment: "")
        default:
            return
        }
        
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        
        onBiometryAvailable?(configuration)
    }
    
    func handleBiometryAuth(completion: @escaping (Bool, AuthorizationError?) -> Void) {
        authService.authorizeIfPossible(completion)
    }
    
}
