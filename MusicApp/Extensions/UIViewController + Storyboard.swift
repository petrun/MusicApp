//
//  UIViewController + Storyboard.swift
//  MusicApp
//
//  Created by andy on 27.02.2021.
//

import UIKit

extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        guard let VC = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Error: Not found initial VC in \(name) storyboard")
        }
        
        return VC
    }
}
