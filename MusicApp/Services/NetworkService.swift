//
//  NetworkService.swift
//  MusicApp
//
//  Created by andy on 25.02.2021.
//

import Foundation
import Alamofire

class NetworkService {
    func fetchTracks(_ searchText: String, completion: @escaping ([Track]) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parameters: [String: Any] = [
            "term": searchText,
            "entity": "song",
            "limit": 10
        ]
        print("fetch url: \(url)")
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .responseDecodable(of: SearchResponse.self) { response in
                guard let items = response.value else {
                    completion([])
                    return
                }
                completion(items.results)
            }
    }
}
