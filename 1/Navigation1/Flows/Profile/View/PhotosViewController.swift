//
//  PhotosViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.08.2024.
//
import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController, ImageLibrarySubscriber {
    private var viewModel: ProfileViewModel!
    private var images: [UIImage] = []
    private var collectionView: UICollectionView?
    private var imagePublisher: ImagePublisherFacade?
    private let backButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupBackButton()
        setupTitleLabel()
        setupCollectionView()
        
        images = PhotosTableViewCell.images
        
        viewModel = ProfileViewModel(user: nil)
        viewModel.onImagesUpdated = { [weak self] images in
            self?.images = images
            self?.collectionView?.reloadData()
        }
        viewModel.subscribeForImages()
    }
    
    private func configureView() {
        view.backgroundColor = AppStyleGuide.Colors.primaryBackground
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle(NSLocalizedString("back", comment: ""), for: .normal)
        backButton.tintColor = AppStyleGuide.Colors.darkBrown
        backButton.titleLabel?.font = AppStyleGuide.Fonts.medium(size: 17)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("photogallery", comment: "")
        titleLabel.font = AppStyleGuide.Fonts.bold(size: 24)
        titleLabel.textColor = AppStyleGuide.Colors.darkBrown
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 8),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCell")
        collectionView?.backgroundColor = AppStyleGuide.Colors.primaryBackground
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        if let collectionView = collectionView {
            view.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            // Apply shadow to collection view
            AppStyleGuide.Effects.applyShadow(to: collectionView)
        }
    }
    
    deinit {
        viewModel.unsubscribeForImages()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCell", for: indexPath) as! PhotosCollectionViewCell
        cell.imageView.image = images[indexPath.item]
        
        // Apply card style to each cell
        AppStyleGuide.Effects.applyCardStyle(to: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8 * 4
        let availableWidth = collectionView.frame.width - padding
        let itemWidth = availableWidth / 3
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

// MARK: - ImageLibrarySubscriber
extension PhotosViewController {
    func receive(images: [UIImage]) {
        self.images = images
        collectionView?.reloadData()
    }
}
