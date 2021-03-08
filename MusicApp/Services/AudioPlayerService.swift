//
//  AudioPlayerService.swift
//  MusicApp
//
//  Created by andy on 04.03.2021.
//

import Foundation
import AVFoundation

protocol AudioPlayerProtocol: class {
    var isPlaying: Bool { get }
    var volume: Float { get set }
    var currentTimeSeconds: Float64 { get }
    var durationSeconds: Float64? { get }
    var duration: CMTime? { get }
    var delegate: AudioPlayerDelegate? { get set }
    
    func add(trackUrlString: String)
    func play()
    func pause()
    func seek(to time: Float64)
    func resetTrack()
}

class AudioPlayer: AVPlayer, AudioPlayerProtocol {
    var duration: CMTime? {
        return self.currentItem?.duration
    }
    
    var isPlaying: Bool {
        return self.rate == 1
    }
    
    var currentTimeSeconds: Float64 {
        return CMTimeGetSeconds(self.currentTime())
    }
    
    var durationSeconds: Float64? {
        guard let duration = self.duration else { return nil }
        return CMTimeGetSeconds(duration)
    }
    
    weak var delegate: AudioPlayerDelegate?
    
    override init() {
        super.init()
        
        self.automaticallyWaitsToMinimizeStalling = false
        self.addObserver(self, forKeyPath: "rate", options: [], context: nil)
        
        let interval = CMTimeMake(value: 1, timescale: 2)
        self.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] currentTime in
            self?.delegate?.timeObserver(currentTime: currentTime)
        }
    }
    
    func resetTrack() {
        self.seek(to: Float64(0))
    }
    
    func seek(to time: Float64) {
        let seekTime = CMTimeMakeWithSeconds(time, preferredTimescale: 1)
        self.seek(to: seekTime)
    }
    
    func add(trackUrlString: String) {
        guard let trackUrl = URL(string: trackUrlString) else {
            return
        }
        let trackItem = AVPlayerItem(url: trackUrl)
        self.replaceCurrentItem(with: trackItem)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate", let player = object as? AVPlayer {
            if player.rate == 1 {
                delegate?.onPlay()
            } else {
                delegate?.onPause()
            }
        }
    }
}

protocol AudioPlayerDelegate: class {
    func onPlay()
    func onPause()
    func timeObserver(currentTime: CMTime)
}
