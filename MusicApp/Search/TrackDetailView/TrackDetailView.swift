//
//  TrackDetailView.swift
//  MusicApp
//
//  Created by andy on 02.03.2021.
//

import UIKit

class TrackDetailView: UIView {
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var currentTimeSlider: UISlider!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var volumeSlider: UISlider!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func dragDownButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: UISlider) {
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
    }
    
    @IBAction func previousTrack(_ sender: UIButton) {
    }
    
    @IBAction func nextTrack(_ sender: UIButton) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: UISlider) {
    }
    
}
