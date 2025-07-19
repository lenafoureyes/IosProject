//
//  BaseCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 13.12.2024.
//

import UIKit
enum AppFlow {
    case profile
    case feed
    case music
}

protocol FlowCoordinator: AnyObject {
    var parentCoordinator: MainBaseCoordinator? { get set }
}

protocol Coordinator: FlowCoordinator {
    var rootViewController: UIViewController { get set }
    func start() -> UIViewController
    @discardableResult func resetToRoot() -> Self
}

extension Coordinator {
    var navigationRootViewController: UINavigationController? {
        return rootViewController as? UINavigationController
    }

    @discardableResult func resetToRoot() -> Self {
        navigationRootViewController?.popToRootViewController(animated: false)
        return self
    }
}

protocol MainBaseCoordinator: Coordinator {
    var profileCoordinator: ProfileBaseCoordinator { get }
    var feedCoordinator: FeedBaseCoordinator { get }
    var musicCoordinator: MusicBaseCoordinator { get }
    func moveTo(flow: AppFlow)
}
