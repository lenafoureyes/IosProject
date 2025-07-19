//
//  TrackViewModel.swift
//  Navigation1
//
//  Created by Елена Хайрова on 17.07.2025.
//
import Foundation
import AVFoundation

class MusicPlayerViewModel: NSObject, AVAudioPlayerDelegate {
    // MARK: - Properties
    private var tracks: [Track]
    private var currentTrackIndex: Int
    private var audioPlayer: AVAudioPlayer?
    private var progressTimer: Timer?
    
    var currentTrack: Track? {
        guard tracks.indices.contains(currentTrackIndex) else { return nil }
        return tracks[currentTrackIndex]
    }
    
    // Callbacks for UI updates
    var didUpdateTrack: ((Track) -> Void)?
    var didUpdatePlaybackState: ((Bool) -> Void)?
    var didUpdateProgress: ((Float, String, String) -> Void)?
    
    var isPlaying: Bool = false {
        didSet {
            didUpdatePlaybackState?(isPlaying)
        }
    }
    
    // MARK: - Initialization
    init(selectedTrack: Track? = nil, allTracks: [Track]? = nil) {
        // Initialize properties first
        if let allTracks = allTracks {
            tracks = allTracks
            currentTrackIndex = allTracks.firstIndex(where: { $0.id == selectedTrack?.id }) ?? 0
        } else {
            tracks = [
                Track(id: 1, title: "chess", artist: "", duration: 180, coverImageName: "aura.image", audioFileName: "chess.mp3"),
                Track(id: 2, title: "zima", artist: "", duration: 210, coverImageName: "zima.image", audioFileName: "zima.mp3"),
                Track(id: 3, title: "Breath", artist: "", duration: 165, coverImageName: "BREATH.image", audioFileName: "BREATH.mp3"),
                Track(id: 4, title: "vielleicht", artist: "", duration: 145, coverImageName: "vielleicht.image", audioFileName:"vielleicht.mp3")
            ]
            currentTrackIndex = 0
        }
        
        super.init()
        
        setupAudioPlayer()
    }
    
    // MARK: - Audio Player Setup
    private func setupAudioPlayer() {
        guard currentTrackIndex < tracks.count else { return }
        let track = tracks[currentTrackIndex]
        
        let fileName = (track.audioFileName as NSString).deletingPathExtension
        let fileExtension = (track.audioFileName as NSString).pathExtension
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileExtension.isEmpty ? nil : fileExtension) else {
            print("❌ File not found: \(fileName).\(fileExtension)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            print("✅ Audio loaded: \(fileName).\(fileExtension)")
        } catch {
            print("❌ Error creating audio player: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Playback Control
    func play() {
        audioPlayer?.play()
        isPlaying = true
        startProgressTimer()
    }
    
    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopProgressTimer()
    }
    
    func playPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func nextTrack() {
        stopProgressTimer()
        audioPlayer?.stop()
        
        currentTrackIndex = (currentTrackIndex + 1) % tracks.count
        setupAudioPlayer()
        
        if isPlaying {
            play()
        }
        
        didUpdateTrack?(tracks[currentTrackIndex])
    }
    
    func previousTrack() {
        stopProgressTimer()
        audioPlayer?.stop()
        
        currentTrackIndex = (currentTrackIndex - 1 + tracks.count) % tracks.count
        setupAudioPlayer()
        
        if isPlaying {
            play()
        }
        
        didUpdateTrack?(tracks[currentTrackIndex])
    }
    
    // MARK: - Progress Tracking
    private func startProgressTimer() {
        stopProgressTimer()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }
    
    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    private func updateProgress() {
        guard let player = audioPlayer else { return }
        
        let progress = Float(player.currentTime / player.duration)
        let currentTimeString = formatTime(player.currentTime)
        let durationString = formatTime(player.duration)
        
        didUpdateProgress?(progress, currentTimeString, durationString)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            nextTrack()
        }
    }
}
