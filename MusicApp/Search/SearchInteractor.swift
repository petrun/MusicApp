//
//  SearchInteractor.swift
//  MusicApp
//
//  Created by andy on 27.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {

    var presenter: SearchPresentationLogic?
    var service: SearchService?

    private let networkService = NetworkService()

    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }

        switch request {
        case .getTracks(searchText: let searchText):
            networkService.fetchTracks(searchText) { [weak self] tracks in
                guard let self = self else { return }
                self.presenter?.presentData(response: .presentTracks(tracks: tracks))
            }
        }
    }

}
