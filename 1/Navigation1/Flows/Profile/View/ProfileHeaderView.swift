//
//  ProfileHeaderView.swift
//  Navigation1
//
//  Created by Елена Хайрова on 17.06.2024.
//

import UIKit

class ProfileHeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cat")
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = AppStyleGuide.Colors.separator.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyleGuide.Fonts.bold(size: 24)
        label.textColor = AppStyleGuide.Colors.darkBrown
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppStyleGuide.Fonts.regular(size: 18)
        label.textColor = AppStyleGuide.Colors.lightBrown
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: CustomButton = {
        let button = CustomButton(
            title: NSLocalizedString("add.post", comment: ""),
            titleColor: .white,
            backgroundColor: AppStyleGuide.Colors.accentGreen,
            cornerRadius: 4,
            useAutoLayout: false,
            shadowColor: AppStyleGuide.Colors.darkBrown.cgColor,
            shadowOffset: CGSize(width: 4, height: 4),
            shadowRadius: 4,
            shadowOpacity: 0.7
        )
        button.action = { [weak self] in
            self?.showImagePicker()
        }
        return button
    }()
    
    var collectionView: UICollectionView!
    let photosLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("photos.label", comment: "")
        label.textColor = AppStyleGuide.Colors.darkBrown
        label.font = AppStyleGuide.Fonts.bold(size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var navigationController: UINavigationController?
    var addPostHandler: ((UIImage, String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppStyleGuide.Colors.primaryBackground
        setupCollectionView()
        setupViews()
        setupConstraints()
        setupAvatarGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAvatarGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func avatarTapped() {
            findProfileViewController()?.showAvatarDetail()
        }
        
        private func findProfileViewController() -> ProfileViewController? {
            var responder: UIResponder? = self
            while responder != nil {
                if let viewController = responder as? ProfileViewController {
                    return viewController
                }
                responder = responder?.next
            }
            return nil
        }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosTableViewCell.self, forCellWithReuseIdentifier: PhotosTableViewCell.reuseIdentifier)
        collectionView.backgroundColor = AppStyleGuide.Colors.primaryBackground
        collectionView.clipsToBounds = true
        addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfItemsPerRow: CGFloat = 4
        let totalSpacing: CGFloat = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0 * (numberOfItemsPerRow - 1)
        let itemWidth = (screenWidth - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    private func setupViews() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(button)
        addSubview(photosLabel)
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 34),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 34),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            button.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            photosLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            photosLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 12),
            
            collectionView.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotosTableViewCell.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosTableViewCell.reuseIdentifier, for: indexPath) as! PhotosTableViewCell
        cell.configure(with: indexPath.item)
        AppStyleGuide.Effects.applyCardStyle(to: cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photosViewController = PhotosViewController()
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        navigationController?.present(imagePicker, animated: true)
    }
}

extension ProfileHeaderView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let alert = UIAlertController(title: NSLocalizedString("add.descrip", comment: ""), message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("post.descrip", comment: "")
        }
        
        let addAction = UIAlertAction(title: NSLocalizedString("add", comment: ""), style: .default) { [weak self] _ in
            guard let description = alert.textFields?.first?.text else { return }
            self?.addPostHandler?(image, description)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        navigationController?.present(alert, animated: true)
    }
}
