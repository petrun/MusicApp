//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by andy on 22.02.2021.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    private let player = Player()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor(hex: "#FD2D55")

        player.setup(view: view, tabBar: tabBar)

        viewControllers = [
            initNavigationViewController(),
            initLibratyViewController()
        ]
    }

    private func initNavigationViewController() -> UIViewController {
        let title = "Search"
        let rootViewController: SearchViewController = SearchViewController.loadFromStoryboard()
        rootViewController.player = player
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = UIImage(named: "search")
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true

        return navigationVC
    }

    private func initLibratyViewController() -> UIViewController {
        var library = LibraryView()
        library.player = player

        let libraryVC = UIHostingController(rootView: library)
        libraryVC.tabBarItem.image = UIImage(named: "library")
        libraryVC.tabBarItem.title = "Libraty"

        return libraryVC
    }
}
