//
//  ProfileCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.12.2024.
//

import UIKit

protocol ProfileBaseCoordinator: Coordinator {
    func showPhotos()
}

class ProfileCoordinator: ProfileBaseCoordinator {

    var parentCoordinator: MainBaseCoordinator?
    var rootViewController: UIViewController

    init() {
        self.rootViewController = UINavigationController()
    }

    func start() -> UIViewController {
        if !isUserLoggedIn() {
            showLogin()
        } else {
            showProfile()
        }
        return rootViewController
    }

    private func isUserLoggedIn() -> Bool {
        return false
    }

    private func showProfile() {
        let profileViewController = ProfileViewController()
        (rootViewController as? UINavigationController)?.pushViewController(profileViewController, animated: false)
    }

    private func showLogin() {
        let loginViewController = LogInViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        self.rootViewController = navigationController
    }

    func showPhotos() {
        let photosViewController = PhotosViewController()
        (rootViewController as? UINavigationController)?.pushViewController(photosViewController, animated: true)
    }
}
