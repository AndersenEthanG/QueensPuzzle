//
//  BoardModels.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation
import SwiftUI


/// Represents the puzzle board and the current placement state of all tiles.
///
/// `Board` is responsible for storing queen placement, determining conflicts,
/// and exposing derived game state such as remaining queens and solved status.
///
/// ## Responsibilities
/// - Store the current tile state for an `n x n` board.
/// - Validate queen placement across rows, columns, and diagonals.
/// - Report whether the puzzle has been solved.
///
/// ## Notes
/// - Valid board sizes are 4 or greater.
// MARK: - Board Model
struct Board {

    // MARK: - Properties
    /// The X, and Y dimensions of the square board
    /// Valid puzzles are 4 or greater.
    /// Validation of this size is handled on a the `BoardSelectionView`
    let boardSize: Int

    private(set) var tiles: [Tile]


    // MARK: - Initializers
    init(boardSize: Int) {
        self.boardSize = boardSize
        self.tiles = Board.setupTiles(boardSize: boardSize)
    }


    // MARK: - Computed Properties
    var queensPlaced: Int {
        tiles.count(where: \.hasQueen)
    }

    var queensRemaining: Int {
        max(0, boardSize - queensPlaced)
    }

    /// Returns an array of  positions of queens on the board that are currently threatened/under attack by another queen.    ///
    var threatenedQueenPositions: [Position] {
        tiles.filter { $0.hasQueen && $0.isThreatened }
            .map(\.position)
    }

    /// Returns true if the board is in a solved/completed state.
    ///
    /// Derived from ensuring all required queens (based on the board size) are placed
    /// and that there are no queens on threatened positions (under attack by another queen).
    var isSolved: Bool {
        if queensPlaced == boardSize {
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


    /// Adds or removes a tile's queen at the given position.
    ///
    /// Calls the function to update the conflicting positions of the entire board.
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
        tiles = Board.setupTiles(boardSize: boardSize)
    }


    // MARK: - Private Methods
    /// Creates the appropriate chess board tiles.
    ///
    /// This function does not read, write, or modify any existing game state, or any persistent data,
    /// rather it simply creates the appropriate 'blank' state board tiles based on the input `boardSize`.
    ///
    /// - Parameters:
    ///   - boardSize: The user inputed board size for the puzzle.
    /// - Returns: An array of `Tile`s in amount and positions appropriate for the input `boardSize`.
    ///
    /// - Note: Should only be called on reset and initialization.
    private static func setupTiles(boardSize: Int) -> [Tile] {
        var returnTiles: [Tile] = []

        for rowInt in 1...boardSize {
            for colInt in 1...boardSize {
                let position = Position(row: rowInt, col: colInt)
                let newTile = Tile(position: position)
                returnTiles.append(newTile)
            }
        }

        return returnTiles
    }


    /// Returns an array of `Tile` objects that currently have queens on them.
    private func queenTiles() -> [Tile] {
        tiles.filter(\.hasQueen)
    }

    /// Updates the `isThreatened` properties of the board's tiles to reflect the current game state.
    /// Called after the user toggles a queen's placement.
    ///
    /// Sets `isThreatened` on all tiles to false,
    /// calculates which tiles are now under threat, based on the position of current queens (tiles in the same row, column, and diagonal),
    /// then updates the appropriate tiles's `isThreatened` property to true.
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


// MARK: - Tile
struct Tile {
    var position: Position
    var hasQueen: Bool = false
    var isThreatened: Bool = false

    // Simple logic to create an alternating checkered board appearance.
    var isLightSquare: Bool {
        (position.row + position.col).isMultiple(of: 2)
    }
}


// MARK: - Position Model
struct Position: Hashable {
    let row: Int
    let col: Int
}
