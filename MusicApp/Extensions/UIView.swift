//
//  UIView.swift
//  MusicApp
//
//  Created by andy on 03.03.2021.
//

import UIKit

extension UIView {
    public func addSubview(_ subview: UIView, stretchToFit: Bool = false) {
        addSubview(subview)
        if stretchToFit {
            subview.translatesAutoresizingMaskIntoConstraints = false
            leftAnchor.constraint(equalTo: subview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: subview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
        }
    }
}
