//
//  GlobalHelpers.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation
import SwiftUI


// MARK: - Global Constants
enum BoardUI {
    static let tileSize: CGFloat = 36

    static let lightColor = Color.gray.opacity(0.3)
    static let darkColor = Color.gray.opacity(0.7)
    static let hasQueenColor = Color.red

    static let queenIcon: String = "♛"
}


// MARK: - Safe index helper
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}


// MARK: - Game Time Formatter
enum GameTimeFormatter {
    static func hourMinuteSecond(from time: TimeInterval, decimals: Int) -> String {
        let totalSeconds = Int(time)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = time.truncatingRemainder(dividingBy: 60)

        let decimals = max(0, decimals)

        let secondsFormat: String = decimals == 0
        ? "%d"
        : "%.\(decimals)f"

        switch (hours, minutes) {
        case let (h, _) where h > 0:
            if decimals == 0 {
                return String(format: "%dh %dm \(secondsFormat)s", hours, minutes, Int(seconds))
            } else {
                return String(format: "%dh %dm \(secondsFormat)s", hours, minutes, seconds)
            }

        case let (_, m) where m > 0:
            if decimals == 0 {
                return String(format: "%dm \(secondsFormat)s", minutes, Int(seconds))
            } else {
                return String(format: "%dm \(secondsFormat)s", minutes, seconds)
            }

        default:
            if decimals == 0 {
                return String(format: "\(secondsFormat)s", Int(seconds))
            } else {
                return String(format: "\(secondsFormat)s", seconds)
            }
        }
    }
}
