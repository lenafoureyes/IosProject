//
//  FeedViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//
import UIKit
class FeedViewController: UIViewController {
    private let viewModel: FeedViewModel
    private let coordinator: FeedBaseCoordinator
    
    private let tableView = UITableView()
    private let favoritesButton = UIButton()
    
    init(viewModel: FeedViewModel, coordinator: FeedBaseCoordinator) {
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
        setupBindings()
        
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(handlePostsUpdate),
                name: NSNotification.Name("PostsUpdated"),
                object: nil
            )
        
    }
    
    @objc private func handlePostsUpdate() {
        // Обновляем данные
        viewModel.refreshPosts() 
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = AppStyleGuide.Colors.primaryBackground
        title = NSLocalizedString("feed.title", comment: "")
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: AppStyleGuide.Colors.darkBrown, 
            .font: AppStyleGuide.Fonts.bold(size: 17)
        ]
        
        // Настройка кнопки избранного в navigation bar
        favoritesButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        favoritesButton.tintColor = AppStyleGuide.Colors.darkBrown
        favoritesButton.addTarget(self, action: #selector(favoritesTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoritesButton)
        
        // Настройка таблицы
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
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
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            viewModel.refreshPosts()
        }
    private func setupBindings() {
            viewModel.onPostsUpdated = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    print("Posts updated. Count: \(self?.viewModel.posts.count ?? 0)")
                }
            }
        }
    
    @objc private func favoritesTapped() {
        coordinator.showFavorites()
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = viewModel.posts[indexPath.row]
        cell.configure(with: post) { [weak self] in
            self?.viewModel.toggleFavorite(for: post.id)
        }
        return cell
    }
}
