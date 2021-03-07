//
//  TracksCache.swift
//  MusicApp
//
//  Created by andy on 07.03.2021.
//

import Foundation

class TracksCache {
    typealias Cell = SearchViewModel.Cell
    typealias Cells = Set<SearchViewModel.Cell>
    
    private let userDefaults = UserDefaults.standard
    private let cacheKey = "tracksLibrary"
    
    static var shared: TracksCache = {
        TracksCache()
    }()

    private init() {}
    
    func add(track: Cell) {
        var listOfTracks = getAll()
        if listOfTracks.contains(track) {
            return
        }
        listOfTracks.insert(track)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(listOfTracks) {
            userDefaults.set(encoded, forKey: cacheKey)
            print("SAVED")
        }
    }
    
    func getAll() -> Cells {
        let decoder = JSONDecoder()
        guard let savedTracks = userDefaults.object(forKey: cacheKey) as? Data,
              let tracks = try? decoder.decode(Cells.self, from: savedTracks) as Cells
        else {
            return Cells()
        }
        
        print("getALL")
        print(tracks.count)
        
        return tracks
    }
    
    func contains(track: Cell) -> Bool {
        getAll().contains(track)
    }
    
}