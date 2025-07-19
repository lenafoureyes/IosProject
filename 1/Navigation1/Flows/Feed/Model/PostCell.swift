//
//  PostCell.swift
//  Navigation1
//
//  Created by Елена Хайрова on 18.07.2025.
//

import UIKit

class PostCell: UITableViewCell {
    private let cardView = UIView()
    private let authorLabel = UILabel()
    private let postTextLabel = UILabel()
    let postImageView = UIImageView()
    private let dateLabel = UILabel()
    let favoriteButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Настройка карточки
        AppStyleGuide.Effects.applyCardStyle(to: cardView)
        AppStyleGuide.Effects.applyShadow(to: cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        // Настройка элементов
        authorLabel.font = AppStyleGuide.Fonts.bold(size: 16)
        authorLabel.textColor = AppStyleGuide.Colors.darkBrown
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(authorLabel)
        
        postTextLabel.font = AppStyleGuide.Fonts.regular(size: 14)
        postTextLabel.textColor = AppStyleGuide.Colors.darkBrown
        postTextLabel.numberOfLines = 0
        postTextLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(postTextLabel)
        
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 8
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(postImageView)
        
        dateLabel.font = AppStyleGuide.Fonts.regular(size: 12)
        dateLabel.textColor = AppStyleGuide.Colors.lightBrown
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dateLabel)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            authorLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            
            favoriteButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            postTextLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            postTextLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            postTextLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            postImageView.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            postImageView.heightAnchor.constraint(equalToConstant: 200),
            
            dateLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with post: Post, favoriteAction: @escaping () -> Void) {
        authorLabel.text = post.author
        postTextLabel.text = post.text
        dateLabel.text = formattedDate(post.date)
        
        // Загрузка изображения
        if let imageName = post.imageName {
            postImageView.image = PostService.shared.loadImage(name: imageName)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
        
        // Получаем актуальное состояние избранного из PostService
        let isFavorite = PostService.shared.isFavorite(postId: post.id)
        let imageName = isFavorite ? "bookmark.fill" : "bookmark"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorite ? AppStyleGuide.Colors.accentGreen : AppStyleGuide.Colors.lightBrown
        
        self.favoriteAction = favoriteAction
    }
    
    private var favoriteAction: (() -> Void)?
    
    @objc private func favoriteButtonTapped() {
        favoriteAction?()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
