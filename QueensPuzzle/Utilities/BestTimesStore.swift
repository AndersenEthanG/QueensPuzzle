//
//  BestTimesStore.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation

// MARK: - Protocols
protocol BestTimeStoring {
    func bestTime(for boardSize: Int) -> TimeInterval?
    func saveBestTime(_ time: TimeInterval, for boardSize: Int)
}


// MARK: - Best Times Store
/// Best times are stored in UserDefaults
/// on a board by board basis.
final class BestTimeStore: BestTimeStoring {
    private let defaults: UserDefaults
    private static let keyPrefix = "com.AndersenEthanG.queensPuzzle.bestTime."

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    private func key(for boardSize: Int) -> String {
        "\(Self.keyPrefix)\(boardSize)"
    }

    func bestTime(for boardSize: Int) -> TimeInterval? {
        let key = key(for: boardSize)
        let stored = defaults.object(forKey: key) as? Double
        return stored
    }
    
    func saveBestTime(_ time: TimeInterval, for boardSize: Int) {
        let key = key(for: boardSize)
        let newTime = time

        if let existing = defaults.object(forKey: key) as? Double {
            guard newTime < existing else { return }
        }

        defaults.set(newTime, forKey: key)
    }
}
