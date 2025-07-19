//
//  MusicCoordinator.swift
//  Navigation1
//
//  Created by Елена Хайрова on 16.07.2025.
//

import UIKit

protocol MusicBaseCoordinator: Coordinator {
    func showMusicPlayer(with track: Track, allTracks: [Track])
}

class MusicCoordinator: MusicBaseCoordinator {
    weak var parentCoordinator: MainBaseCoordinator?
    var rootViewController: UIViewController
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() -> UIViewController {
        let musicVC = MusicViewController()
        musicVC.coordinator = self
        (rootViewController as? UINavigationController)?.viewControllers = [musicVC]
        return rootViewController
    }
    
    func showMusicPlayer(with track: Track, allTracks: [Track]) {
        let viewModel = MusicPlayerViewModel(selectedTrack: track, allTracks: allTracks)
        let playerVC = MusicPlayerViewController(viewModel: viewModel, coordinator: self)
        (rootViewController as? UINavigationController)?.pushViewController(playerVC, animated: true)
    }
}
