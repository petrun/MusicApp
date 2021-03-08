//
//  TrackCell.swift
//  MusicApp
//
//  Created by andy on 01.03.2021.
//

import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCell: UITableViewCell {
    static let reuseId = "TrackCell"
    
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var collectionNameLabel: UILabel!
    @IBOutlet var addTrackButton: UIButton!
    
    private var cell: SearchViewModel.Cell?
    private let tracksCache = TracksCache.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.clipsToBounds = true
        trackImageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        addTrackButton.layer.isHidden = false
        trackImageView.image = nil
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        cell = viewModel
        
        let isInLibrary = tracksCache.contains(track: viewModel)
        
        addTrackButton.layer.isHidden = isInLibrary
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let iconUrl = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: iconUrl)
    }
    
    @IBAction func addTrackAction() {
        guard let cell = cell else { return }
        
        tracksCache.add(track: cell)
        
        addTrackButton.layer.isHidden = true
        
//        tracksCache.getAll().map { track in
//            print(track.trackId)
//            print(track.trackName)
//        }
    }
}
