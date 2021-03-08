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
            stretch(subview: subview)
            //            subview.translatesAutoresizingMaskIntoConstraints = false
            //            leftAnchor.constraint(equalTo: subview.leftAnchor).isActive = true
            //            rightAnchor.constraint(equalTo: subview.rightAnchor).isActive = true
            //            topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
            //            bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
        }
    }
    
    public func stretch(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        subview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        //        leftAnchor.constraint(equalTo: subview.leftAnchor).isActive = true
        //        rightAnchor.constraint(equalTo: subview.rightAnchor).isActive = true
        //        topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
        //        bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
    }
    
    class func loadFromNib<T: UIView>() -> T {
        guard let view = Bundle.main.loadNibNamed(String(describing: T.self), owner: self)?.first as? T else {
            fatalError("Can't load from nib \(T.self)")
        }

        return view
    }
}
