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
    
    let tracks = [
        TrackModel(trackName: "First track", artistName: "Frist artist"),
        TrackModel(trackName: "Second track", artistName: "Second artist")
    ]
    
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
        
        let url = "https://itunes.apple.com/search?term=\(searchText)"
        AF.request(url).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("Error request from: \(url) error: \(error)")
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            let result = String(data: data, encoding: .utf8)
            print(result ?? "")
        }
    }
}
