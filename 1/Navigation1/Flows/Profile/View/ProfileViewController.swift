//
//  ProfileViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 29.05.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel!
    var user: User?
    private var posts: [Post] = []
    private let tableView = UITableView()
    private var headerView: ProfileHeaderView?
    private let overlayView = UIView()
    private let closeButton = UIButton()
    private var avatarImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ProfileViewModel(user: user)
        posts = PostService.shared.getProfilePosts()
        
        setupTableView()
        setupHeaderView()
        setupOverlayView()
        setupCloseButton()
        setupNotifications()
        
        viewModel.onImagesUpdated = { [weak self] images in
            self?.headerView?.collectionView.reloadData()
        }
        
        viewModel.onPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.posts = PostService.shared.getProfilePosts()
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.subscribeForImages()
        
        #if DEBUG
            tableView.backgroundColor = AppStyleGuide.Colors.secondaryBackground
        #else
            tableView.backgroundColor = AppStyleGuide.Colors.primaryBackground
        #endif
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.unsubscribeForImages()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePostsUpdate),
            name: NSNotification.Name("PostsUpdated"),
            object: nil
        )
    }
    
    private func setupHeaderView() {
        headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        headerView?.navigationController = navigationController
        
        headerView?.addPostHandler = { [weak self] image, description in
            self?.createNewPost(image: image, description: description)
        }
        
        if let user = user {
            headerView?.nameLabel.text = user.fullName
            headerView?.descriptionLabel.text = user.status
            headerView?.avatarImageView.image = user.avatar
        }
        
        tableView.tableHeaderView = headerView
    }
    
    private func createNewPost(image: UIImage, description: String) {
        let imageName = "post_\(UUID().uuidString)"
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: FileManager.getDocumentsDirectory().appendingPathComponent("\(imageName).jpg"))
        }
        
        let newPost = Post(
            id: UUID().uuidString,
            author: user?.fullName ?? "Meow_Master",
            text: description,
            imageName: imageName,
            isFavorite: false,
            date: Date(),
            postType: .both
        )
        
        PostService.shared.addPost(newPost)
    }
    
    @objc private func handlePostsUpdate() {
        posts = PostService.shared.getProfilePosts()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostTableViewCell")
        tableView.allowsMultipleSelectionDuringEditing = false
    }

    private func setupOverlayView() {
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        overlayView.isHidden = true
        view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.alpha = 0.0
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func showAvatarDetail() {
        guard let headerView = headerView else { return }
        let avatarImageView = headerView.avatarImageView

        avatarImageView.removeFromSuperview()
        view.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = true

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        UIView.animate(withDuration: 0.5, animations: {
            avatarImageView.frame = CGRect(
                x: 0,
                y: (screenHeight - screenWidth * (avatarImageView.frame.height / avatarImageView.frame.width)) / 2,
                width: screenWidth,
                height: screenWidth * (avatarImageView.frame.height / avatarImageView.frame.width)
            )
            avatarImageView.layer.cornerRadius = 0
            self.overlayView.isHidden = false
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.closeButton.alpha = 1.0
            })
        }
    }

    @objc private func closeButtonTapped() {
        guard let headerView = headerView else { return }
        let avatarImageView = headerView.avatarImageView
        
        UIView.animate(withDuration: 0.3, animations: {
            self.closeButton.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                avatarImageView.frame = CGRect(x: 16, y: 16, width: 150, height: 150)
                avatarImageView.layer.cornerRadius = 75
                self.overlayView.isHidden = true
            }) { _ in
                headerView.addSubview(avatarImageView)
                NSLayoutConstraint.activate([
                    avatarImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
                    avatarImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                    avatarImageView.widthAnchor.constraint(equalToConstant: 150),
                    avatarImageView.heightAnchor.constraint(equalToConstant: 150)
                ])
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let avatarImageView = avatarImageView {
            let screenWidth = UIScreen.main.bounds.width
            avatarImageView.frame.size.width = screenWidth
            avatarImageView.frame.size.height = screenWidth * (avatarImageView.frame.height / avatarImageView.frame.width)
        }
    }
}

// MARK: - TableView DataSource and Delegate
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        if let imageName = post.imageName {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathComponent("\(imageName).jpg")
            cell.postImageView.image = UIImage(contentsOfFile: imagePath.path)
        } else {
            cell.postImageView.image = nil
        }
        
        cell.configure(with: post) { [weak self] in
            PostService.shared.toggleFavorite(postId: post.id)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let imageName = PostService.shared.isFavorite(postId: post.id) ? "bookmark.fill" : "bookmark"
        cell.favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        cell.favoriteButton.tintColor = PostService.shared.isFavorite(postId: post.id) ?
            AppStyleGuide.Colors.accentGreen : AppStyleGuide.Colors.lightBrown
        
        return cell
    }
    
    // Добавляем возможность удаления постов
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = posts[indexPath.row]
            confirmDelete(post: post, at: indexPath)
        }
    }
    
    private func confirmDelete(post: Post, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: NSLocalizedString("delete.button.title", comment: ""),
            message: NSLocalizedString("alert.confirm.title", comment: ""),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("delete.button.title", comment: ""), style: .destructive) { [weak self] _ in
            self?.deletePost(post: post, at: indexPath)
        })
        
        present(alert, animated: true)
    }
    
    private func deletePost(post: Post, at indexPath: IndexPath) {
        // Удаляем изображение если есть
        if let imageName = post.imageName {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathComponent("\(imageName).jpg")
            try? FileManager.default.removeItem(at: imagePath)
        }
        
        // Удаляем из сервиса
        PostService.shared.deletePost(postId: post.id)
        
        // Удаляем из локального массива
        posts.remove(at: indexPath.row)
        
        // Обновляем таблицу
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        // Отправляем уведомление об обновлении (чтобы обновилась и лента)
        NotificationCenter.default.post(name: NSNotification.Name("PostsUpdated"), object: nil)
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let headerView = headerView else { return }
        let offsetY = scrollView.contentOffset.y
        headerView.frame.origin.y = offsetY > 0 ? -offsetY : 0
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let alert = UIAlertController(title: NSLocalizedString("new.post", comment: ""), message: NSLocalizedString("enter.description", comment: ""), preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("description", comment: "")
        }
        
        let addAction = UIAlertAction(title: NSLocalizedString("add", comment: ""), style: .default) { [weak self] _ in
            guard let description = alert.textFields?.first?.text else { return }
            
            let imageName = "post_\(UUID().uuidString)"
            
            if PostService.shared.saveImage(image, name: imageName) {
                let newPost = Post(
                    id: UUID().uuidString,
                    author: self?.user?.fullName ?? "Meow_Master",
                    text: description,
                    imageName: imageName,
                    isFavorite: false,
                    date: Date(),
                    postType: .both
                )
                
                PostService.shared.addPost(newPost)
            } else {
                self?.showAlert(title: NSLocalizedString("error.title", comment: ""), message: NSLocalizedString("faled.save.img", comment: ""))
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("general.ok", comment: ""), style: .default))
        present(alert, animated: true)
    }
}
