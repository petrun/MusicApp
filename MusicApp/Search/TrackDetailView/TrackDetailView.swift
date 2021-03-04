//
//  TrackDetailView.swift
//  MusicApp
//
//  Created by andy on 02.03.2021.
//

import UIKit
import AVFoundation

class TrackDetailView: UIView {
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var currentTimeSlider: UISlider!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var volumeSlider: UISlider!
    
    private var player: AudioPlayerProtocol = AudioPlayer()
    private let scale: CGFloat = 0.8
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Setup
    
    func set(viewModel: SearchViewModel.Cell) {
        trackNameLabel.text = viewModel.trackName
        authorNameLabel.text = viewModel.artistName
        
        let trackImageUrlString = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        if let trackImageUrl = URL(string: trackImageUrlString ?? "") {
            trackImageView.sd_setImage(with: trackImageUrl)
        }
        
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        volumeSlider.value = player.volume
        currentTimeSlider.value = 0
        
        player.delegate = self
        player.addTrack(viewModel.previewUrl)
        player.play()
    }
    
    
    // MARK: - Time Setup
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = player.currentTimeSeconds
        guard let durationSeconds = player.durationSeconds else { return }
        let percentage = currentTimeSeconds / durationSeconds
        currentTimeSlider.value = Float(percentage)
    }
    
    // MARK: - Animations
    
    private func enlargeTrackImageView() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: .curveEaseInOut
        ) {
            self.trackImageView.transform = .identity
        }
    }
    
    private func reduceTrackImageView() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1,
            options: .curveEaseInOut
        ) {
            self.trackImageView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
        guard let durationSeconds = player.durationSeconds else { return }
        let percentage = currentTimeSlider.value
        let seekTimeSeconds = Float64(percentage) * durationSeconds
        player.seek(to: seekTimeSeconds)
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        guard let durationSeconds = player.durationSeconds else { return }
        let currentTimeSeconds = player.currentTimeSeconds
        
        if currentTimeSeconds == durationSeconds {
            player.resetTrack()
        }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @IBAction func previousTrack(_ sender: UIButton) {
        
    }
    
    @IBAction func nextTrack(_ sender: UIButton) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
}

extension TrackDetailView: AudioPlayerDelegate {
    func onPlay() {
        enlargeTrackImageView()
        playPauseButton.setImage(UIImage.init(named: "Pause Button"), for: .normal)
    }
    
    func onPause() {
        reduceTrackImageView()
        playPauseButton.setImage(UIImage.init(named: "Play Button"), for: .normal)
    }
    
    func timeObserver(currentTime: CMTime) {
        currentTimeLabel.text = currentTime.toDisplayString()
        
        guard let durationTime = player.duration else { return }
        let durationTimeText = (durationTime - currentTime).toDisplayString()
        
        durationLabel.text = "-\(durationTimeText)"
        updateCurrentTimeSlider()
    }
    
}
