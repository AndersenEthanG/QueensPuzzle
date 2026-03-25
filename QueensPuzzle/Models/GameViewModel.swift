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
        self.board = Board(size: boardSize)
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

    func userTapped(at position: Position) {
        board.toggleQueen(at: position)

        if board.isSolved {
            stopGame()
            userWon()
        }
    }

    func toggleHints() {
        showHints.toggle()
    }

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

    private func updateElapsedTime() {
        guard let startDate else { return }
        elapsedTime = Date().timeIntervalSince(startDate)
    }

    private func userWon() {
        guard let startDate else { return }

        let elapsed = Date().timeIntervalSince(startDate)
        elapsedTime = elapsed
        bestTimeStore.saveBestTime(elapsed, for: boardSize)
        bestTime = bestTimeStore.bestTime(for: boardSize)

        showWinScreen = true
    }
}
