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

    static func setupTiles(size: Int) -> [Tile] {
        var returnTiles: [Tile] = []

        for rowInt in 1...size {
            for colInt in 1...size {
                let position = Position(row: rowInt, col: colInt)
                let newTile = Tile(position: position)
                returnTiles.append(newTile)
            }
        }

        return returnTiles
    }
}


// MARK: - Safe index helper
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
