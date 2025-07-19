//
//  MainCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 13.12.2024.
//

import UIKit

class MainCoordinator: MainBaseCoordinator {
    
    var parentCoordinator: MainBaseCoordinator?
    var profileCoordinator: ProfileBaseCoordinator
    var feedCoordinator: FeedBaseCoordinator
    var musicCoordinator: MusicBaseCoordinator
    var rootViewController: UIViewController
    
    init() {
        self.profileCoordinator = ProfileCoordinator()
        self.feedCoordinator = FeedCoordinator()
        self.musicCoordinator = MusicCoordinator()
        self.rootViewController = UITabBarController()
        configureTabBarAppearance()
    }
    
    private func configureTabBarAppearance() {
        let tabBar = UITabBar.appearance()
        tabBar.backgroundColor = AppStyleGuide.Colors.primaryBackground
        tabBar.tintColor = AppStyleGuide.Colors.accentGreen
        tabBar.unselectedItemTintColor = AppStyleGuide.Colors.lightBrown
        
        if let tabBarController = rootViewController as? UITabBarController {
            tabBarController.tabBar.backgroundColor = AppStyleGuide.Colors.primaryBackground
            tabBarController.tabBar.tintColor = AppStyleGuide.Colors.accentGreen
            tabBarController.tabBar.unselectedItemTintColor = AppStyleGuide.Colors.lightBrown
        }
    }
    
    func start() -> UIViewController {
        let profileViewController = profileCoordinator.start()
        profileViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab.profile", comment: "Profile tab title"),
            image: UIImage(systemName: "person.circle"),
            selectedImage: nil
        )
        
        let feedViewController = feedCoordinator.start()
        feedViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab.feed", comment: "Feed tab title"),
            image: UIImage(systemName: "doc.richtext"),
            selectedImage: nil
        )
        
        let musicViewController = musicCoordinator.start()
        musicViewController.tabBarItem = UITabBarItem(
            title: "Music",
            image: UIImage(systemName: "music.note"),
            selectedImage: nil
        )
        
        (rootViewController as? UITabBarController)?.viewControllers = [
            profileViewController,
            feedViewController,
            musicViewController
        ]
        
        return rootViewController
    }
    
    func moveTo(flow: AppFlow) {
        switch flow {
        case .profile:
            (rootViewController as? UITabBarController)?.selectedIndex = 0
        case .feed:
            (rootViewController as? UITabBarController)?.selectedIndex = 1
        case .music:
            (rootViewController as? UITabBarController)?.selectedIndex = 2
        }
    }
    
    func resetToRoot() -> Self {
        profileCoordinator.resetToRoot()
        moveTo(flow: .profile)
        return self
    }
}
