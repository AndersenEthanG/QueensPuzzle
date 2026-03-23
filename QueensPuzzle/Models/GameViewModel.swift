//
//  GameViewModel.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation
import Combine


// MARK: - Game View Model
@MainActor
final class GameViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published private(set) var board: Board
    @Published var showHints: Bool = false
    @Published var showWinScreen: Bool = false
    @Published private(set) var elapsedTime: TimeInterval = 0


    // MARK: - Properties
    let boardSize: Int


    // MARK: - Initializers
    init(boardSize: Int) {
        self.boardSize = boardSize
        self.board = Board(size: boardSize)
    }


    // MARK: - Computed Properties
    var queensRemaining: Int {
        board.queensRemaining
    }


    // MARK: - Methods
    func tile(at position: Position) -> Tile {
        board.tile(at: position)
    }

    func userTapped(at position: Position) {
        board.toggleQueen(at: position)

        if board.isSolved {
            showWinScreen = true
        }
    }

    func toggleHints() {
        showHints.toggle()
    }

    func resetGame() {
        board = Board(size: boardSize)
        showHints = false
        showWinScreen = false
        elapsedTime = 0
    }
}
