//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by andy on 22.02.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .white
        
        tabBar.tintColor = UIColor(hex: "#FD2D55")
        
        let searchVC = SearchViewController()
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
}
