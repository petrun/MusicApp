//
//  TracksCache.swift
//  MusicApp
//
//  Created by andy on 07.03.2021.
//

import Foundation

class TracksCache {
    typealias Track = SearchViewModel.Cell
    typealias Tracks = [SearchViewModel.Cell]
    
    private let userDefaults = UserDefaults.standard
    private let cacheKey = "tracksLibrary"
    private var tracksList: Tracks!
    
    static var shared: TracksCache = TracksCache()

    private init() {
        tracksList = self.loadAllFromStore()
    }
    
    func add(track: Track) {
        if tracksList.contains(track) {
            return
        }
        tracksList.append(track)
        
        save(tracksList)
    }
    
    func getAll() -> Tracks {
        return tracksList
    }
    
    func deleteBy(id: String) {
        if let indexToRemove = tracksList.firstIndex(where: { $0.id == id }) {
            tracksList.remove(at: indexToRemove)
        }

        save(tracksList)
     }
    
    func contains(track: Track) -> Bool {
        tracksList.contains(track)
    }

    private func loadAllFromStore() -> Tracks {
        let decoder = JSONDecoder()
        guard let savedTracks = userDefaults.object(forKey: cacheKey) as? Data,
              let tracks = try? decoder.decode(Tracks.self, from: savedTracks) as Tracks
        else {
            return Tracks()
        }

        return tracks
    }

    private func save(_ tracksList: Tracks) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tracksList) {
            userDefaults.set(encoded, forKey: cacheKey)
        }
    }

}
