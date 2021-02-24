//
//  Collection.swift
//  MusicApp
//
//  Created by andy on 22.02.2021.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
