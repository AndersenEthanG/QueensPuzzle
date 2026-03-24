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
    private let bestTimeStore = BestTimeStore()
    private var timerCancellable: AnyCancellable?


    // MARK: - Initializers
    init(boardSize: Int) {
        self.boardSize = boardSize
        self.board = Board(size: boardSize)
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

        if board.hasQueen(at: position) {
            SoundManager.shared.play(.place)
        } else {
            SoundManager.shared.play(.remove)
        }

        if board.isSolved {
            stopGame()
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
        gameEnded = false
    }

    func stopGame() {
        gameEnded = true
        stopTimer()
        guard let startDate else { return }

        let elapsed = Date().timeIntervalSince(startDate)
        elapsedTime = elapsed
        bestTimeStore.saveBestTime(elapsed, for: boardSize)
        bestTime = bestTimeStore.bestTime(for: boardSize)
        SoundManager.shared.play(.win)
    }

    @MainActor
    private func startTimer() {
        stopTimer()

        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
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
}
