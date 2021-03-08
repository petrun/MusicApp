//
//  TrackDetailView.swift
//  MusicApp
//
//  Created by andy on 02.03.2021.
//

import UIKit
import AVFoundation

protocol PlayListDelegate {
    func getNextTrack() -> SearchViewModel.Cell?
    func getPreviousTrack() -> SearchViewModel.Cell?
}

protocol ResizeDelegate: class {
    func minimizePlayer()
    func maximizePlayer(viewModel: SearchViewModel.Cell?)
}

class PlayerView: UIView {
    
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
    var playListDelegate: PlayListDelegate?
    weak var resizeDelegate: ResizeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.clipsToBounds = true
        trackImageView.layer.cornerRadius = 5
        
        miniTrackImageView.clipsToBounds = true
        miniTrackImageView.layer.cornerRadius = 5
        
        setupGestures()
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
    
    // MARK: - Gestures
    
    private func setupGestures() {
        miniPlayerContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniPlayerContainer.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    @objc private func handleTapMaximized() {
        resizeDelegate?.maximizePlayer(viewModel: nil)
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        @unknown default:
            print("default case")
        }
    }
    
    @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        
        switch gesture.state {
        case .changed:
            playerContainer.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 1,
                options: .curveEaseOut
            ) { [weak self] in
                self?.playerContainer.transform = .identity
                
                if translation.y > 50 {
                    self?.resizeDelegate?.minimizePlayer()
                }
            }

        @unknown default:
            print("default case")
        }
    }
    
    func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        miniPlayerContainer.alpha = max(newAlpha, 0)
        playerContainer.alpha = -translation.y/200
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut
        ) { [weak self] in
            self?.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self?.resizeDelegate?.maximizePlayer(viewModel: nil)
            } else {
                self?.miniPlayerContainer.alpha = 1
                self?.playerContainer.alpha = 0
            }
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
        resizeDelegate?.minimizePlayer()
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
        guard let track = playListDelegate?.getPreviousTrack() else { return }
        set(viewModel: track)
    }

    @IBAction func nextTrack() {
        guard let track = playListDelegate?.getNextTrack() else { return }
        set(viewModel: track)
    }

    @IBAction func handleVolumeSlider() {
        player.volume = volumeSlider.value
    }
    
}

extension PlayerView: AudioPlayerDelegate {
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
