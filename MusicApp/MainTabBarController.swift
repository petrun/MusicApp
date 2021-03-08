//
//  MainTabBarController.swift
//  MusicApp
//
//  Created by andy on 22.02.2021.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = UIColor(hex: "#FD2D55")

        initPlayer()

        viewControllers = [
            initNavigationViewController(),
            initLibratyViewController()
        ]
    }

    private func initNavigationViewController() -> UIViewController {
        let title = "Search"
        let rootViewController: SearchViewController = SearchViewController.loadFromStoryboard()
        rootViewController.player = Player.shared
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = UIImage(named: "search")
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true

        return navigationVC
    }

    private func initLibratyViewController() -> UIViewController {
        var library = LibraryView()
        library.player = Player.shared

        let libraryVC = UIHostingController(rootView: library)
        libraryVC.tabBarItem.image = UIImage(named: "library")
        libraryVC.tabBarItem.title = "Libraty"

        return libraryVC
    }

    private func initPlayer() {
        Player.shared.setup(view: view, tabBar: tabBar)
    }
}
