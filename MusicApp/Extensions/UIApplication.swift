//
//  UIApplication.swift
//  MusicApp
//
//  Created by andy on 06.03.2021.
//

import UIKit

extension UIApplication {
//        let window = UIApplication.shared.keyWindow
//        'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes
    func getKeyWindow() -> UIWindow? {
        return self.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow }).first
    }
}
