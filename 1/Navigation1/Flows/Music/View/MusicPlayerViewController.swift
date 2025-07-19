//
//  MusicViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.07.2025.
//

import UIKit

class MusicPlayerViewController: UIViewController {
    private let viewModel: MusicPlayerViewModel
    private let coordinator: MusicBaseCoordinator
    
    private let backgroundView = UIView()
    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let progressView = UIProgressView()
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    private let controlStack = UIStackView()
    private let prevButton = UIButton()
    private let playPauseButton = UIButton()
    private let nextButton = UIButton()
    
    init(viewModel: MusicPlayerViewModel, coordinator: MusicBaseCoordinator) {
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
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = AppStyleGuide.Colors.primaryBackground
        
        
        // Cover Image
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true
        coverImageView.layer.borderWidth = 2
        coverImageView.layer.borderColor = AppStyleGuide.Colors.separator.cgColor
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(coverImageView)
        
        // Title Label
        titleLabel.font = AppStyleGuide.Fonts.bold(size: 22)
        titleLabel.textColor = AppStyleGuide.Colors.darkBrown
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Artist Label
        artistLabel.font = AppStyleGuide.Fonts.medium(size: 16)
        artistLabel.textColor = AppStyleGuide.Colors.lightBrown
        artistLabel.textAlignment = .center
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(artistLabel)
        
        // Progress View
        progressView.progressTintColor = AppStyleGuide.Colors.accentGreen
        progressView.trackTintColor = AppStyleGuide.Colors.separator.withAlphaComponent(0.3)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        // Time Labels
        currentTimeLabel.font = AppStyleGuide.Fonts.regular(size: 12)
        currentTimeLabel.textColor = AppStyleGuide.Colors.lightBrown
        currentTimeLabel.text = "0:00"
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        durationLabel.font = AppStyleGuide.Fonts.regular(size: 12)
        durationLabel.textColor = AppStyleGuide.Colors.lightBrown
        durationLabel.text = "0:00"
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timeStack = UIStackView(arrangedSubviews: [currentTimeLabel, durationLabel])
        timeStack.axis = .horizontal
        timeStack.distribution = .equalSpacing
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timeStack)
        
        // Control Buttons
        prevButton.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        prevButton.tintColor = AppStyleGuide.Colors.darkBrown
        prevButton.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
        
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.tintColor = AppStyleGuide.Colors.darkBrown
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        playPauseButton.backgroundColor = AppStyleGuide.Colors.accentGreen
        playPauseButton.layer.cornerRadius = 30
        playPauseButton.layer.masksToBounds = true
        
        nextButton.setImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        nextButton.tintColor = AppStyleGuide.Colors.darkBrown
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        controlStack.axis = .horizontal
        controlStack.distribution = .equalSpacing
        controlStack.alignment = .center
        controlStack.spacing = 40
        controlStack.translatesAutoresizingMaskIntoConstraints = false
        controlStack.addArrangedSubview(prevButton)
        controlStack.addArrangedSubview(playPauseButton)
        controlStack.addArrangedSubview(nextButton)
        view.addSubview(controlStack)
        
        // Constraints
        NSLayoutConstraint.activate([

            
            coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            coverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coverImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            progressView.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 32),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            timeStack.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            timeStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            timeStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            controlStack.topAnchor.constraint(equalTo: timeStack.bottomAnchor, constant: 32),
            controlStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            playPauseButton.widthAnchor.constraint(equalToConstant: 60),
            playPauseButton.heightAnchor.constraint(equalToConstant: 60),
            
            prevButton.widthAnchor.constraint(equalToConstant: 40),
            prevButton.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.widthAnchor.constraint(equalToConstant: 40),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupBindings() {
        viewModel.didUpdateProgress = { [weak self] progress, currentTime, duration in
            self?.progressView.setProgress(progress, animated: true)
            self?.currentTimeLabel.text = currentTime
            self?.durationLabel.text = duration
        }
        
        viewModel.didUpdateTrack = { [weak self] track in
            self?.updateUI(with: track)
        }
        
        viewModel.didUpdatePlaybackState = { [weak self] isPlaying in
            let imageName = isPlaying ? "pause.fill" : "play.fill"
            self?.playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    
    private func updateUI(with track: Track? = nil) {
        let currentTrack = track ?? viewModel.currentTrack
        titleLabel.text = currentTrack?.title
        artistLabel.text = currentTrack?.artist
        
        if let imageName = currentTrack?.coverImageName {
            coverImageView.image = UIImage(named: imageName)
        }
    }
    
    @objc private func playPauseTapped() {
        viewModel.playPause()
    }
    
    @objc private func nextTapped() {
        viewModel.nextTrack()
    }
    
    @objc private func prevTapped() {
        viewModel.previousTrack()
    }
}
