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

    // MARK: - Properties
    @Published private(set) var board: Board
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published private(set) var bestTime: TimeInterval?
    @Published private(set) var gameEnded: Bool = false
    @Published var showWinScreen: Bool = false
    @Published var showHints: Bool = false

    let boardSize: Int
    private var startDate: Date?
    private let bestTimeStore: BestTimeStoring
    private var timerCancellable: AnyCancellable?


    // MARK: - Initializers
    init(boardSize: Int, bestTimeStore: BestTimeStoring) {
        self.boardSize = boardSize
        self.board = Board(boardSize: boardSize)
        self.bestTimeStore = bestTimeStore
    }

    deinit {
        timerCancellable?.cancel()
    }


    // MARK: - Computed Properties
    var queensRemaining: Int {
        board.queensRemaining
    }


    // MARK: - Methods
    func startGame() {
        startDate = Date()
        elapsedTime = 0
        startTimer()
    }

    func tile(at position: Position) -> Tile {
        board.tile(at: position)
    }

    /// Handles functionality for when a user taps a tile.
    ///
    /// Toggles the tile's queen state.
    /// Checks if the board is in a solved state.
    ///
    /// - Parameters:
    ///   - position: The position of the tile that the user taped.
    ///
    /// - Note: Toggle and solved logic are handled on the `Board` model.
    func userTapped(at position: Position) {
        board.toggleQueen(at: position)

        if board.isSolved {
            userWon()
        }
    }

    func toggleHints() {
        showHints.toggle()
    }


    /// Resets the board to it's initial game state.
    ///
    /// Resets the tiles to their base state,
    /// resets the timer,
    /// and ensures that hints and the win screen are not showing.
    func resetGame() {
        stopGame()

        board.reset()
        gameEnded = false
        showHints = false
        showWinScreen = false

        startGame()
    }

    func stopGame() {
        gameEnded = true
        stopTimer()
    }

    /// Starts a timer for visual UI purposes.
    ///
    /// The real-time score is kept by calculating a start and end `Date` upon view initialization and puzzle completion respectively.
    @MainActor
    private func startTimer() {
        stopTimer()

        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                self.updateElapsedTime()
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    /// Updates the value used in the UI timer.
    ///
    /// This is not used in the actual best time score calculation
    private func updateElapsedTime() {
        guard let startDate else { return }
        elapsedTime = Date().timeIntervalSince(startDate)
    }

    /// Handles the functionality for when the board is in a completed/won state.
    ///
    /// Stops the game,
    /// calcultes the real elapsed time,
    /// updates the classe's `bestTime` property to reflect this value,
    /// triggers to show win screen.
    ///
    /// While all elapsedTimes are passed in, the logic for saving the actual best time is handled on the `BestTimeStore`.
    private func userWon() {
        stopGame()

        guard let startDate else { return }

        let elapsed = Date().timeIntervalSince(startDate)
        elapsedTime = elapsed
        bestTimeStore.saveBestTime(elapsed, for: boardSize)
        bestTime = bestTimeStore.bestTime(for: boardSize)

        showWinScreen = true
    }
}
