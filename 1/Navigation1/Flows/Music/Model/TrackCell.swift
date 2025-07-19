//
//  TrackCell.swift
//  Navigation1
//
//  Created by Елена Хайрова on 17.07.2025.
//

import UIKit


class TrackCell: UITableViewCell {
    static let reuseIdentifier = "TrackCell"
    
    private let containerView = UIView()
    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let durationLabel = UILabel()
    private let playIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with track: Track) {
        titleLabel.text = track.title
        durationLabel.text = formatTime(Int(track.duration))
        coverImageView.image = UIImage(named: track.coverImageName)
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        // Container
        containerView.backgroundColor = AppStyleGuide.Colors.secondaryBackground
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = AppStyleGuide.Colors.separator.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Cover Image
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 8
        coverImageView.clipsToBounds = true
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(coverImageView)
        
        // Title Label
        titleLabel.font = AppStyleGuide.Fonts.medium(size: 16)
        titleLabel.textColor = AppStyleGuide.Colors.darkBrown
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Duration Label
        durationLabel.font = AppStyleGuide.Fonts.regular(size: 14)
        durationLabel.textColor = AppStyleGuide.Colors.lightBrown
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(durationLabel)
        
        // Play Icon
        playIcon.image = UIImage(systemName: "play.fill")
        playIcon.tintColor = AppStyleGuide.Colors.accentGreen
        playIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(playIcon)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            coverImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            coverImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: 40),
            coverImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -8),
            
            durationLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            durationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            playIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            playIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            playIcon.widthAnchor.constraint(equalToConstant: 20),
            playIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
