//
//  TrackDetailView.swift
//  MusicApp
//
//  Created by andy on 02.03.2021.
//

import UIKit
import AVFoundation

protocol TrackListDelegate: class {
    func getNextTrack() -> SearchViewModel.Cell?
    func getPreviousTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
    // MARK: - Mini Player Outlets
    
    @IBOutlet var miniPlayerContainer: UIView!
    @IBOutlet var miniTrackImageView: UIImageView!
    @IBOutlet var miniTrackNameLabel: UILabel!
    @IBOutlet var miniPlayPauseButton: UIButton!
    
    // MARK: - Main Player Outlets
    
    @IBOutlet var playerContainer: UIStackView!
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
    weak var delegate: TrackListDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Setup
    
    func set(viewModel: SearchViewModel.Cell) {
        miniPlayerInit(viewModel: viewModel)
        
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
        guard let previewUrl = viewModel.previewUrl else { return }
        player.add(trackUrlString: previewUrl)
        player.play()
    }
    
    private func miniPlayerInit(viewModel: SearchViewModel.Cell) {
        miniTrackNameLabel.text = viewModel.trackName
        
        if let miniTrackImageUrl = URL(string: viewModel.iconUrlString ?? "") {
            miniTrackImageView.sd_setImage(with: miniTrackImageUrl)
        }
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
    @IBAction func dragDownButtonTapped() {
        tabBarDelegate?.minimizeTrackDetailContoller()
    }
    
    @IBAction func handleCurrentTimeSlider() {
        guard let durationSeconds = player.durationSeconds else { return }
        let percentage = currentTimeSlider.value
        let seekTimeSeconds = Float64(percentage) * durationSeconds
        player.seek(to: seekTimeSeconds)
    }

    @IBAction func playPauseAction() {
        if player.currentTimeSeconds == player.durationSeconds {
            player.resetTrack()
        }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }

    @IBAction func previousTrack() {
        guard let track = delegate?.getPreviousTrack() else { return }
        set(viewModel: track)
    }

    @IBAction func nextTrack() {
        guard let track = delegate?.getNextTrack() else { return }
        set(viewModel: track)
    }

    @IBAction func handleVolumeSlider() {
        player.volume = volumeSlider.value
    }
    
}

extension TrackDetailView: AudioPlayerDelegate {
    func onPlay() {
        enlargeTrackImageView()
        playPauseButton.setImage(UIImage.init(named: "Pause Button"), for: .normal)
        miniPlayPauseButton.setImage(UIImage.init(named: "Pause Button"), for: .normal)
    }
    
    func onPause() {
        reduceTrackImageView()
        playPauseButton.setImage(UIImage.init(named: "Play Button"), for: .normal)
        miniPlayPauseButton.setImage(UIImage.init(named: "Play Button"), for: .normal)
    }
    
    func timeObserver(currentTime: CMTime) {
        currentTimeLabel.text = currentTime.toDisplayString()
        
        guard let durationTime = player.duration else { return }
        let durationTimeText = (durationTime - currentTime).toDisplayString()
        
        durationLabel.text = "-\(durationTimeText)"
        updateCurrentTimeSlider()
    }
    
}
