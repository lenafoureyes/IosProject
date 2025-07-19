//
//  PhotosTableViewCell.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.08.2024.
//

import UIKit

class PhotosTableViewCell: UICollectionViewCell {
    static var images: [UIImage] = {
        let imageNames = [
            "cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8",
            "cat9", "cat10", "cat11", "cat12", "cat13", "cat14", "cat15",
            "cat16", "cat17", "cat18", "cat19", "cat20"
        ]
        return imageNames.compactMap { UIImage(named: $0) }
    }()

    static let reuseIdentifier = "PhotosTableViewCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        contentView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
    }
    
    func configure(with index: Int) {
        imageView.image = PhotosTableViewCell.images[index]
    }
}
