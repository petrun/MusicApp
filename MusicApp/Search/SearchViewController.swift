//
//  SearchViewController.swift
//  MusicApp
//
//  Created by andy on 27.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    weak var player: Player?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer?
    private lazy var footerView = FooterView()
    
    @IBOutlet var table: UITableView!
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchInteractor()
        let presenter             = SearchPresenter()
        let router                = SearchRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func setupTableView() {
        let trackCellNib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(trackCellNib, forCellReuseIdentifier: TrackCell.reuseId)
        table.tableFooterView = footerView
    }
    
    func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayTracks(searchViewModel: let searchViewModel):
            self.searchViewModel = searchViewModel
            table.reloadData()
            footerView.hideLoader()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        let cellViewModel = searchViewModel.cells[indexPath.row]
        
        cell.set(viewModel: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        searchViewModel.cells.isEmpty ? 250 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.row]

        player?.play(viewModel: cellViewModel, playListDelegate: self)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.footerView.showLoader()
            self?.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchText: searchText))
        }
    }
}


extension SearchViewController: PlayListDelegate {
    private func getTrack(isNextTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        
        let newIndex = isNextTrack ? indexPath.row + 1 : indexPath.row - 1
        guard newIndex >= 0 && newIndex < searchViewModel.cells.count else { return nil }
        
        let newIndexPath = IndexPath(row: newIndex, section: indexPath.section)
        
        table.selectRow(at: newIndexPath, animated: false, scrollPosition: .top)
        return searchViewModel.cells[newIndex]
    }
    
    func getNextTrack() -> SearchViewModel.Cell? {
        getTrack(isNextTrack: true)
    }
    
    func getPreviousTrack() -> SearchViewModel.Cell? {
        getTrack(isNextTrack: false)
    }
}
