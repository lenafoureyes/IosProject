//
//  FavoritesViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 18.07.2025.
//

import UIKit

class FavoritesViewController: UIViewController {
    private let viewModel: FavoritesViewModel
        private weak var coordinator: FeedBaseCoordinator?
    
    private var favoritePosts: [Post] = []
    private let tableView = UITableView()
    
    init(viewModel: FavoritesViewModel, coordinator: FeedBaseCoordinator?) {
            self.viewModel = viewModel
            self.coordinator = coordinator
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFavoritePosts()
    }
    
    private func setupUI() {
        view.backgroundColor = AppStyleGuide.Colors.primaryBackground
        title = NSLocalizedString("favorites.title", comment: "")
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadFavoritePosts() {
        favoritePosts = PostService.shared.getFavoritePosts() // Берем из единого источника
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoritePosts() // Обновляем при каждом открытии
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePosts.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostCell
        let post = favoritePosts[indexPath.row]
        
        cell.configure(with: post) { [weak self] in
            PostService.shared.toggleFavorite(postId: post.id)
            self?.loadFavoritePosts()
        }
        
        // Установка иконки избранного
        cell.favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        cell.favoriteButton.tintColor = AppStyleGuide.Colors.accentGreen
        
        return cell
    }
}
