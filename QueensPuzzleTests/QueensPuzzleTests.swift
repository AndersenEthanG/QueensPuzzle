//
//  QueensPuzzleTests.swift
//  QueensPuzzleTests
//
//  Created by Ethan Andersen on 3/25/26.
//

import Foundation
import Testing
@testable import QueensPuzzle


// MARK: - Board model tests
@Suite("Board model tests.")
struct BoardTests {

    @Test("Initialization and basic counts.")
    func initializationAndBasics() {
        var board = Board(boardSize: 4)

        #expect(board.tiles.count == 16)
        #expect(board.queensPlaced == 0)
        #expect(board.queensRemaining == 4)
        #expect(board.isSolved == false)

        // Light/dark squares should alternate in a checkerboard pattern.
        #expect(board.tile(at: Position(row: 1, col: 1)).isLightSquare == true)
        #expect(board.tile(at: Position(row: 1, col: 2)).isLightSquare == false)

        // Toggling this property should add and remove a queen from a tile.
        let p = Position(row: 1, col: 1)
        board.toggleQueen(at: p)
        #expect(board.hasQueen(at: p))
        #expect(board.queensPlaced == 1)
        #expect(board.queensRemaining == 3)

        board.toggleQueen(at: p)
        #expect(board.hasQueen(at: p) == false)
        #expect(board.queensPlaced == 0)
        #expect(board.queensRemaining == 4)
    }

    @Test("Threat updates from a single queen.")
    func threatUpdates() {
        var board = Board(boardSize: 4)
        let q = Position(row: 2, col: 2)
        board.toggleQueen(at: q)

        // The queen's own tile should not mark itself as threatened.
        #expect(board.tile(at: q).isThreatened == false)

        // Tiles on the same row as the queen should be threatened.
        #expect(board.tile(at: Position(row: 2, col: 1)).isThreatened)

        // Tiles in the same column as the queen should be threatened.
        #expect(board.tile(at: Position(row: 1, col: 2)).isThreatened)

        // Tiles in the diagonals of the queen should be threatened.
        #expect(board.tile(at: Position(row: 1, col: 1)).isThreatened)
        #expect(board.tile(at: Position(row: 3, col: 3)).isThreatened)
        #expect(board.tile(at: Position(row: 3, col: 1)).isThreatened)

        // This tile should not be threatened based on this test board's current state.
        #expect(board.tile(at: Position(row: 1, col: 4)).isThreatened == false)
    }

    @Test("Removing a queen recalculates threats.")
    func removingQueenRecalculatesThreats() {
        var board = Board(boardSize: 4)
        let p1 = Position(row: 1, col: 1)
        let p2 = Position(row: 1, col: 3)

        board.toggleQueen(at: p1)
        board.toggleQueen(at: p2)

        #expect(board.threatenedQueenPositions.isEmpty == false)

        board.toggleQueen(at: p2)

        #expect(board.hasQueen(at: p2) == false)
        #expect(board.threatenedQueenPositions.isEmpty)
        #expect(board.isSolved == false)
    }

    @Test("Solved detection for a known 4×4 solution.")
    func solvedDetection() {
        var board = Board(boardSize: 4)

        // A real solution for a board size of 4x4.
        let solution = [
            Position(row: 1, col: 2),
            Position(row: 2, col: 4),
            Position(row: 3, col: 1),
            Position(row: 4, col: 3),
        ]

        // Put the queens on the board.
        for p in solution {
            board.toggleQueen(at: p)
        }

        #expect(board.queensPlaced == 4)
        #expect(board.threatenedQueenPositions.isEmpty)
        #expect(board.isSolved == true)
    }

    @Test("Cannot place more than N queens.")
    func cannotPlaceMoreThanNQueens() {

        // Create a board.
        var board = Board(boardSize: 4)

        // Select positions for 5 queens.
        let p1 = Position(row: 1, col: 1)
        let p2 = Position(row: 1, col: 2)
        let p3 = Position(row: 1, col: 3)
        let p4 = Position(row: 1, col: 4)
        let p5 = Position(row: 2, col: 1)

        // Put a valid 4 queens on the board.
        board.toggleQueen(at: p1)
        board.toggleQueen(at: p2)
        board.toggleQueen(at: p3)
        board.toggleQueen(at: p4)
        #expect(board.queensRemaining == 0)


        // Attempt to put a fifth queen.
        board.toggleQueen(at: p5)
        #expect(board.hasQueen(at: p5) == false)
        #expect(board.queensPlaced == 4)
    }

    @Test("Conflicting queens do not count as solved.")
    func conflictingBoardIsNotSolved() {
        var board = Board(boardSize: 4)

        board.toggleQueen(at: Position(row: 1, col: 1))
        board.toggleQueen(at: Position(row: 1, col: 3))

        #expect(board.isSolved == false)
        #expect(board.threatenedQueenPositions.isEmpty == false)
    }
}


// MARK: - Game time formatting tests
// In the current version of the app, these tests are simply a formality.
// If the app were to be localized in other languages, then this struct would support and test for proper language changes.
@Suite("Game time formatter.")
struct GameTimeFormatterTests {

    @Test("Formats seconds, minutes, and hours with and without decimals.")
    func formattingExamples() {
        #expect(GameTimeFormatter.hourMinuteSecond(from: 0, decimals: 0) == "0s")
        #expect(GameTimeFormatter.hourMinuteSecond(from: 59.4, decimals: 0) == "59s")
        #expect(GameTimeFormatter.hourMinuteSecond(from: 59.4, decimals: 2) == "59.40s")

        #expect(GameTimeFormatter.hourMinuteSecond(from: 61.25, decimals: 0) == "1m 1s")
        #expect(GameTimeFormatter.hourMinuteSecond(from: 61.25, decimals: 2) == "1m 1.25s")

        #expect(GameTimeFormatter.hourMinuteSecond(from: 3661.7, decimals: 2) == "1h 1m 1.70s")
    }
}


// MARK: - BestTimeStore tests
@Suite("Best time store.")
struct BestTimeStoreTests {

    @Test("Saves only better (smaller) times per board size.")
    func savesOnlyBetterTimes() {
        // Using a different UserDefaults suite than the regular app, so tests don't interfere with real data.
        let suiteName = "QueensPuzzleTests_BestTimeStore"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let store = BestTimeStore(userDefaults: defaults)

        #expect(store.bestTime(for: 4) == nil)

        store.saveBestTime(10.0, for: 4)
        #expect(store.bestTime(for: 4) == 10.0)

        // Worse time should be ignored.
        store.saveBestTime(12.0, for: 4)
        #expect(store.bestTime(for: 4) == 10.0)

        // Better time should replace new ones.
        store.saveBestTime(9.0, for: 4)
        #expect(store.bestTime(for: 4) == 9.0)
    }

    @Test("Best times are stored separately per board size.")
    func storesBestTimesPerBoardSize() {
        let suiteName = "QueensPuzzleTests_BestTimeStore_PerBoardSize"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let store = BestTimeStore(userDefaults: defaults)

        store.saveBestTime(10.0, for: 4)
        store.saveBestTime(20.0, for: 5)

        #expect(store.bestTime(for: 4) == 10.0)
        #expect(store.bestTime(for: 5) == 20.0)
    }
}


// MARK: - GameViewModel tests
// Similar to the Board tests, but ensuring the GameViewModel is properly integrated.
@Suite("Game view model")
@MainActor
struct GameViewModelTests {

    @Test("Winning flow ends the game, shows win screen, and persists best time.")
    func winningFlowSavesBestTimeAndEndsGame() {
        let store = InMemoryBestTimeStore()
        let vm = GameViewModel(boardSize: 4, bestTimeStore: store)

        vm.startGame()

        // A real solution for a board size of 4x4.
        let solution = [
            Position(row: 1, col: 2),
            Position(row: 2, col: 4),
            Position(row: 3, col: 1),
            Position(row: 4, col: 3),
        ]

        // Toggle the first three tiles to have a queen on them.
        for p in solution.dropLast() {
            vm.userTapped(at: p)
        }

        #expect(vm.gameEnded == false)

        // Add a queen to the last tile.
        vm.userTapped(at: solution.last!)
        #expect(vm.gameEnded == true)
        #expect(vm.showWinScreen == true)
        #expect(vm.bestTime != nil)
        #expect(store.bestTime(for: 4) == vm.bestTime)
    }

    @Test("Reset restores initial state and restarts timing.")
    func resetGameResetsState() {
        let store = InMemoryBestTimeStore()
        let vm = GameViewModel(boardSize: 4, bestTimeStore: store)

        vm.startGame()

        // A real solution for a board size of 4.
        // Qucikly putting queens on each of the solution tiles.
        [Position(row: 1, col: 2),
         Position(row: 2, col: 4),
         Position(row: 3, col: 1),
         Position(row: 4, col: 3)]
            .forEach { vm.userTapped(at: $0) }

        #expect(vm.gameEnded == true)
        #expect(vm.showWinScreen == true)

        // Test reset functionality.
        vm.resetGame()

        #expect(vm.gameEnded == false)
        #expect(vm.showWinScreen == false)
        #expect(vm.queensRemaining == 4)
        #expect(vm.showHints == false)
        #expect(vm.elapsedTime == 0)
    }
}


// MARK: - Test support
// A simple in-memory store to use in view model tests.
final class InMemoryBestTimeStore: BestTimeStoring {
    private var storage: [Int: TimeInterval] = [:]

    func bestTime(for boardSize: Int) -> TimeInterval? {
        storage[boardSize]
    }

    func saveBestTime(_ time: TimeInterval, for boardSize: Int) {
        if let existing = storage[boardSize], existing <= time { return }
        storage[boardSize] = time
    }
}
