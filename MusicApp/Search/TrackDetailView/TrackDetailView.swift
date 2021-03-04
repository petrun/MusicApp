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
        
//        monitorStartTime()
        observePlayerCurrentTime()
        initPlayer(viewModel.previewUrl)
        volumeSlider.value = player.volume
        currentTimeSlider.value = 0
        
        player.play()
    }
    
    private func initPlayer(_ trackUrlString: String?) {
        guard let trackUrl = URL(string: trackUrlString ?? "") else {
            return
        }
        let trackItem = AVPlayerItem(url: trackUrl)
        player.replaceCurrentItem(with: trackItem)
        player.addObserver(self, forKeyPath: "rate", options: [], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate", let player = object as? AVPlayer {
            if player.rate == 1 {
                print("Playing")
                enlargeTrackImageView()
                playPauseButton.setImage(UIImage.init(named: "Pause Button"), for: .normal)
            } else {
                print("Paused")
                reduceTrackImageView()
                playPauseButton.setImage(UIImage.init(named: "Play Button"), for: .normal)
            }
        }
    }
    
    // MARK: - Time Setup
    
//    private func monitorStartTime() {
//        let time = CMTimeMake(value: 1, timescale: 3)
//        let times = [NSValue(time: time)]
//        
//        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
//            self?.enlargeTrackImageView()
//        }
//    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)

        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (currentTime) in
            guard let self = self else { return }
            self.currentTimeLabel.text = currentTime.toDisplayString()
            
            guard let durationTime = self.player.currentItem?.duration else { return }
            let durationTimeText = (durationTime - currentTime).toDisplayString()
            
            self.durationLabel.text = "-\(durationTimeText)"
            self.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
        let percentage = currentTimeSeconds / durationSeconds
        currentTimeSlider.value = Float(percentage)
    }
    
    private func resetTrack() {
        let seekTime = CMTimeMakeWithSeconds(0, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    deinit {
        print("DEINIT")
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
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        guard let duration = player.currentItem?.duration else { return }
        let durationSeconds = CMTimeGetSeconds(duration)
//        let percentage = currentTimeSeconds / durationSeconds
//        currentTimeSlider.value = Float(percentage)
        
        
        if currentTimeSeconds == durationSeconds {
            print("END PLAY")
            resetTrack()
        }
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
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
