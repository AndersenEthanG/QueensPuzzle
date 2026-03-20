//
//  GlobalHelpers.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation
import SwiftUI


// MARK: - Global Constants
struct GlobalConstants {
    static let minBoardSize: Int = 4
    static let maxBoardSize: Int = 8

    static let tileSize: CGFloat = 36

    static let lightColor = Color.gray.opacity(0.3)
    static let darkColor = Color.gray.opacity(0.7)
    static let hasQueenColor = Color.red

    static let queenIcon: String = "♛"
}


// MARK: - Safe index helper
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
