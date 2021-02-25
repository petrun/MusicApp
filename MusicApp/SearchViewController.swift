//
//  SearchViewController.swift
//  MusicApp
//
//  Created by andy on 22.02.2021.
//

import UIKit
import Alamofire

struct TrackModel {
    var trackName: String
    var artistName: String
}

class SearchViewController: UITableViewController {
    
    private var timer: Timer?
    
    var tracks: [Track] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        guard let track = tracks[safeIndex: indexPath.row] else {
            return cell
        }
//        let track = tracks[indexPath.row]
        
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = UIImage(named: "track1")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self, searchText] _ in
            self?.responseData(searchText) { tracks in
                self?.tracks = tracks
                self?.tableView.reloadData()
            }
        })
    }
    
    func responseData(_ searchText: String, completion: @escaping ([Track]) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parameters: [String:Any] = [
            "term": searchText,
            "entity": "song",
            "limit": 10
        ]
        print("fetch url: \(url)")
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
//        AF.request(url)
            .responseDecodable(of: SearchResponse.self) { response in
                guard let items = response.value else { return }
                print("OK1")
                print(items)
//                completion: @escaping (CachedURLResponse?) -> Void)
//                self.tracks = items.results
                completion(items.results)
          }
        
//        AF.request(url).responseData { (dataResponse) in
//            if let error = dataResponse.error {
//                print("Error request from: \(url) error: \(error)")
//                return
//            }
//
//            guard let data = dataResponse.data else { return }
//
//            let decoder = JSONDecoder()
//            do {
//                let objects = try decoder.decode(SearchResponse.self, from: data)
//                print("object:", objects)
//            } catch {
//                print("Failed to decode JSON", error.localizedDescription)
//                return
//            }
//
////            let result = String(data: data, encoding: .utf8)
////            print(result ?? "")
//        }
    }
}
