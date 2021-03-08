//
//  SearchModels.swift
//  MusicApp
//
//  Created by andy on 27.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SwiftUI

enum Search {
    enum Model {
        struct Request {
            enum RequestType {
                case getTracks(searchText: String)
            }
        }
        struct Response {
            enum ResponseType {
                case presentTracks(tracks: [Track])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayTracks(searchViewModel: SearchViewModel)
            }
        }
    }
}

struct SearchViewModel {
    struct Cell: TrackCellViewModel, Codable, Hashable, Identifiable {
        var id: String { String(trackId) }
        var trackId: Int64
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        var previewUrl: String?
    }
    
    let cells: [Cell]
}
