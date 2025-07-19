//
//  FeedCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.12.2024.
//

import UIKit

protocol FeedBaseCoordinator: Coordinator, AnyObject {
    func showFavorites()
}

class FeedCoordinator: FeedBaseCoordinator {
    var rootViewController: UIViewController
    var parentCoordinator: MainBaseCoordinator?
    private let feedViewModel: FeedViewModel
    
    init() {
        self.rootViewController = UINavigationController()
        self.feedViewModel = FeedViewModel()
        setupNavigationBarAppearance()
    }
    
    func start() -> UIViewController {
        let feedViewController = FeedViewController(viewModel: feedViewModel, coordinator: self)
        configureFeedViewController(feedViewController)
        
        if let navController = rootViewController as? UINavigationController {
            navController.setViewControllers([feedViewController], animated: false)
        }
        
        return rootViewController
    }
    
    @objc func showFavorites() {
        let favoritePosts = PostService.shared.getFavoritePosts()  // Получаем посты напрямую из PostService
        let favoritesVC = createFavoritesViewController(with: favoritePosts)
        
        if let navController = rootViewController as? UINavigationController {
            navController.pushViewController(favoritesVC, animated: true)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppStyleGuide.Colors.primaryBackground
        appearance.titleTextAttributes = [.foregroundColor: AppStyleGuide.Colors.darkBrown]
        appearance.largeTitleTextAttributes = [.foregroundColor: AppStyleGuide.Colors.darkBrown]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func configureFeedViewController(_ vc: FeedViewController) {
        vc.navigationItem.largeTitleDisplayMode = .always
        vc.title = NSLocalizedString("tab.feed", comment: "")
        
        let favoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(showFavorites)
        )
        favoritesButton.tintColor = AppStyleGuide.Colors.darkBrown
        vc.navigationItem.rightBarButtonItem = favoritesButton
    }
    
    private func createFavoritesViewController(with posts: [Post]) -> UIViewController {
        // 1. Создаем ViewModel
        let viewModel = FavoritesViewModel()
        viewModel.favoritePosts = posts
        
        // 2. Создаем ViewController
        let viewController = FavoritesViewController(
            viewModel: viewModel,
            coordinator: self 
        )
        
        // 3. Настройка navigation
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Лента",
            style: .plain,
            target: nil,
            action: nil
        )
        viewController.title = "Избранное"
        
        return viewController
    }
}
