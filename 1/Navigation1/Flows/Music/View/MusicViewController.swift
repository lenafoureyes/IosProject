//
//  MusicViewController.swift
//  Navigation1
//
//  Created by Елена Хайрова on 17.07.2025.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController {
    weak var coordinator: MusicBaseCoordinator?
    
    private let tableView = UITableView()
    private let tracks: [Track] = [
        Track(id: 1, title: "Chess", artist: "Nature Sounds", duration: 180, coverImageName: "aura.image", audioFileName: "chess.mp3"),
        Track(id: 2, title: "Zima", artist: "Forest Melodies", duration: 210, coverImageName: "zima.image", audioFileName: "zima.mp3"),
        Track(id: 3, title: "Breath", artist: "Meditation", duration: 165, coverImageName: "BREATH.image", audioFileName: "BREATH.mp3"),
        Track(id: 4, title: "Vielleicht", artist: "Ambient", duration: 145, coverImageName: "vielleicht.image", audioFileName:"vielleicht.mp3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = NSLocalizedString("music.myMusic.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: AppStyleGuide.Colors.darkBrown, // Пример из вашего кода
            .font: AppStyleGuide.Fonts.bold(size: 17) // Пример из вашего кода
        ]
    }
    
    private func setupUI() {
        view.backgroundColor = AppStyleGuide.Colors.primaryBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 72
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MusicViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier, for: indexPath) as? TrackCell else {
            fatalError("Unable to dequeue TrackCell")
        }
        
        let track = tracks[indexPath.row]
        cell.configure(with: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTrack = tracks[indexPath.row]
        coordinator?.showMusicPlayer(with: selectedTrack, allTracks: tracks)
    }
}

