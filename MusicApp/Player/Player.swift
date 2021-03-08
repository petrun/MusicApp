//
// Created by andy on 08.03.2021.
//

import Foundation
import UIKit

class Player {
    private let playerView: PlayerView

    private var view: UIView!
    private var tabBar: UITabBar!

    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!

    static var shared = Player()

    private init() {
        playerView = PlayerView.loadFromNib()
        playerView.resizeDelegate = self
    }

    public func setup(view: UIView, tabBar: UITabBar) {
        self.view = view
        self.tabBar = tabBar

        view.insertSubview(playerView, belowSubview: tabBar)

        minimizedTopAnchorConstraint = playerView.topAnchor
            .constraint(equalTo: tabBar.topAnchor, constant: -64)
        maximizedTopAnchorConstraint = playerView.topAnchor
            .constraint(equalTo: view.topAnchor, constant: view.frame.height)
        bottomAnchorConstraint = playerView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor, constant: view.frame.height)

        bottomAnchorConstraint.isActive = true

        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        maximizedTopAnchorConstraint.isActive = true
    }

    public func play(viewModel: SearchViewModel.Cell, playListDelegate: PlayListDelegate) {
        maximizePlayer(viewModel: viewModel)
        playerView.playListDelegate = playListDelegate
    }

    public func minimize() {
        minimizePlayer()
    }
}

extension Player: ResizeDelegate {
    func maximizePlayer(viewModel: SearchViewModel.Cell?) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
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
            self.playerView.miniPlayerContainer.alpha = 0
            self.playerView.playerContainer.alpha = 1
        }

        guard let viewModel = viewModel else { return }
        playerView.set(viewModel: viewModel)
    }


    func minimizePlayer() {
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
            self.playerView.miniPlayerContainer.alpha = 1
            self.playerView.playerContainer.alpha = 0
        }
    }
}
