//
//  BoardModels.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation
import SwiftUI


// MARK: - Board Model
struct Board {

    // MARK: - Properties
    let size: Int
    private(set) var tiles: [Tile]


    // MARK: - Initializers
    init(size: Int) {
        self.size = size
        self.tiles = Board.setupTiles(size: size)
    }


    // MARK: - Computed Properties
    var queensPlaced: Int {
        tiles.count(where: \.hasQueen)
    }

    var queensRemaining: Int {
        max(0, size - queensPlaced)
    }

    var threatenedQueenPositions: [Position] {
        tiles.filter { $0.hasQueen && $0.isThreatened }
            .map(\.position)
    }

    /// While there are ways to make this property more concise, we can avoid unnecessary computation by spreading out the properties to check.
    var isSolved: Bool {
        if queensPlaced == size {
            if threatenedQueenPositions.isEmpty {
                return true
            }
        }

        return false
    }


    // MARK: - Public Methods
    func tile(at position: Position) -> Tile {
        guard let tile = tiles.first(where: { $0.position == position }) else {
            fatalError("Missing tile at position: \(position)")
        }
        return tile
    }

    func hasQueen(at position: Position) -> Bool {
        tiles.first(where: { $0.position == position })?.hasQueen == true
    }

    mutating func toggleQueen(at position: Position) {
        guard let index = tiles.firstIndex(where: { $0.position == position }) else { return }

        if tiles[index].hasQueen {
            tiles[index].hasQueen = false
            updateConflictingPositions()
        } else if queensRemaining > 0 {
            tiles[index].hasQueen = true
            updateConflictingPositions()
        }
    }

    mutating func reset() {
        tiles = Board.setupTiles(size: size)
    }


    // MARK: - Private Methods
    private static func setupTiles(size: Int) -> [Tile] {
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

    private func queenTiles() -> [Tile] {
        tiles.filter(\.hasQueen)
    }

    mutating private func updateConflictingPositions() {
        for index in tiles.indices {
            tiles[index].isThreatened = false
        }

        let queens = queenTiles()

        for queen in queens {
            for index in tiles.indices {
                let tilePosition = tiles[index].position
                let queenPosition = queen.position

                guard tilePosition != queenPosition else { continue }

                let sharesRow = tilePosition.row == queenPosition.row
                let sharesColumn = tilePosition.col == queenPosition.col
                let sharesDiagonal =
                    abs(tilePosition.row - queenPosition.row) ==
                    abs(tilePosition.col - queenPosition.col)

                if sharesRow || sharesColumn || sharesDiagonal {
                    tiles[index].isThreatened = true
                }
            }
        }
    }
}


// MARK: - TileState
struct Tile {
    var position: Position
    var hasQueen: Bool = false
    var isThreatened: Bool = false

    var isLightSquare: Bool {
        (position.row + position.col).isMultiple(of: 2)
    }
}


// MARK: - Position Model
struct Position: Hashable {
    let row: Int
    let col: Int
}
