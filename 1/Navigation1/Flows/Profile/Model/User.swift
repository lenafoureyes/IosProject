//
//  User.swift
//  Navigation1
//
//  Created by Елена Хайрова on 12.10.2024.
//

import UIKit

class User {
    let login: String
    let fullName: String
    let avatar: UIImage
    let status: String
    
    init(login: String, fullName: String, avatar: UIImage, status: String) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}

protocol UserService {
    func getUser(byLogin login: String) -> User?
}

class CurrentUserService: UserService {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func getUser(byLogin login: String) -> User? {
        print(NSLocalizedString("debug.comparingLogin", comment: "Comparing with user login:") + " \(user.login)")
        return login == user.login ? user : nil
    }
}

class TestUserService: UserService {
    private var testUser: User
    private let testPassword = "123"
    
    init() {
        guard let avatar = UIImage(named: "testAvatar") else {
            fatalError(NSLocalizedString("error.avatarNotFound", comment: "Avatar image not found"))
        }
        
        testUser = User(
            login: "testUser", 
            fullName: "Test User",
            avatar: avatar,
            status: "Testing"
        )
    }
    
    func getUser(byLogin login: String) -> User? {
        return login == testUser.login ? testUser : nil
    }
    
    func checkCredentials(login: String, password: String) -> Bool {
        return login == testUser.login && password == testPassword
    }
}
