//
//  CMTime.swift
//  MusicApp
//
//  Created by andy on 04.03.2021.
//

import Foundation
import AVFoundation

extension CMTime {
    
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
