//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by andy on 22.02.2021.
//

import UIKit

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailContoller()
    func maximizeTrackDetailContoller(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    private let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    private let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchVC.tabBarDelegate = self
        tabBar.tintColor = UIColor(hex: "#FD2D55")
        setupTrackDetailView()
        
        let libraryVC = LibraryViewController()
        
        viewControllers  = [
            generateViewController(rootViewController: searchVC, image: UIImage(named: "search"), title: "Search"),
            generateViewController(rootViewController: libraryVC, image: UIImage(named: "library"), title: "Library")
        ]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage?, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    private func setupTrackDetailView() {
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstraint.isActive = true
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        trackDetailView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trackDetailView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        maximizedTopAnchorConstraint.isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizeTrackDetailContoller(viewModel: SearchViewModel.Cell?) {
        maximizedTopAnchorConstraint.isActive = true
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1,
            options: .curveEaseOut
        ) {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniPlayerContainer.alpha = 0
            self.trackDetailView.playerContainer.alpha = 1
        }
        
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
    }
    
    
    func minimizeTrackDetailContoller() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1,
            options: .curveEaseOut
        ) {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView.miniPlayerContainer.alpha = 1
            self.trackDetailView.playerContainer.alpha = 0
        }
    }
    
}
