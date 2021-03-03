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
    
    let player: AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        
        return player
    }()
    
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
        
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        monitorStartTime()
        setTrack(viewModel.previewUrl)
        playTrack()
    }
    
    private func setTrack(_ trackUrlString: String?) {
        guard let trackUrl = URL(string: trackUrlString ?? "") else {
            return
        }
        let trackItem = AVPlayerItem(url: trackUrl)
        player.replaceCurrentItem(with: trackItem)
    }
    
    private func playTrack() {
        playPauseButton.setImage(UIImage.init(named: "Pause Button"), for: .normal)
        player.play()
        enlargeTrackImageView()
    }
    
    private func pauseTrack() {
        playPauseButton.setImage(UIImage.init(named: "Play Button"), for: .normal)
        player.pause()
        reduceTrackImageView()
    }
    
    // MARK: - Time Setup
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
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
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        if player.timeControlStatus == .paused {
            playTrack()
        } else {
            pauseTrack()
        }
    }
    
    @IBAction func previousTrack(_ sender: UIButton) {
        
    }
    
    @IBAction func nextTrack(_ sender: UIButton) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
    }
    
}
