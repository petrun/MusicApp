//
//  SearchResponse.swift
//  MusicApp
//
//  Created by andy on 25.02.2021.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var artistName: String
    var collectionName: String?
    var trackName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
