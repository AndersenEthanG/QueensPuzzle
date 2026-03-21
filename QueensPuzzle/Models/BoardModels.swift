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
        self.tiles = GlobalConstants.setupTiles(size: size)
    }


    // MARK: - Computed Properties
    var queensPlaced: Int {
        tiles.count(where: \.hasQueen)
    }

    var queensRemaining: Int {
        max(0, size - queensPlaced)
    }

    var conflictingPositions: [Position] {
        tiles
            .filter(\.isConflicting)
            .map(\.position)
    }

    var isSolved: Bool {
        queensPlaced == size && conflictingPositions.isEmpty
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

        tiles[index].hasQueen.toggle()
        updateConflictingPositions()
    }

    mutating func reset() {
        tiles = GlobalConstants.setupTiles(size: size)
    }


    // MARK: - Private Methods
    private func queenTiles() -> [Tile] {
        tiles.filter(\.hasQueen)
    }

    mutating private func updateConflictingPositions() {
        for index in tiles.indices {
            tiles[index].isConflicting = false
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
                    tiles[index].isConflicting = true
                }
            }
        }
    }
}


// MARK: - TileState
struct Tile {
    var position: Position
    var hasQueen: Bool = false
    var isConflicting: Bool = false

    var isLightSquare: Bool {
        (position.row + position.col).isMultiple(of: 2)
    }
}


// MARK: - Position Model
struct Position: Hashable {
    let row: Int
    let col: Int
}
