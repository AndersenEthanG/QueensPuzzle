//
//  GlobalHelpers.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation
import SwiftUI


// MARK: - Global Helpers
enum BoardUI {
    static let tileSize: CGFloat = 36

    static let darkSquareColor = Color(hex: 0x739552)
    static let lightSquareColor = Color(hex: 0xEBECD0)
    static let hasQueenColor = Color.red

    static let backgroundTop = Color(hex: 0x0B1B0F)
    static let backgroundBottom = Color(hex: 0x1F3B22)
    static let accent = Color(hex: 0x4CAF50)
}

enum Assets {
    static let blackQueen = "blackQueenIcon"
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


// MARK: - Extensions
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}


extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
