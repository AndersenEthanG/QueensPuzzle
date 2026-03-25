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
    /// Square color hex codes obtained from Chess.com's default chessboard squares.
    static let darkSquareColor = Color(hex: 0x739552)
    static let lightSquareColor = Color(hex: 0xEBECD0)

    static let hasQueenColor = Color.red
}

enum Assets {
    /// The default black queen icon, obtained from Chess.com's default chessboard.
    static let blackQueen = "blackQueenIcon"
}


// MARK: - Game Time Formatter
enum GameTimeFormatter {

    /// A helper function to convert a Swift TimeInterval type to a human-readable `String`.
    ///
    /// The return String's formatting is dependant on the expected output.
    /// Example variance outputs:
    /// 1h 15m 10.15s
    /// 5m 15.1s - Note that "h" (hours" was excluded, since it was 0.
    /// 4s - Note that no "." (point/period) is displayed if there are no fractions of a second/the `decimal` input was 0.
    ///
    /// - Parameters:
    ///   - time: A `TimeInterval` value.
    ///   - decimals: An `Int` for the desired number of trailing decimals after the whole seconds.
    /// - Returns: A human-readable `String` representing the input TimeInterval.
    ///
    /// - Note: This does not handle any language localizations.
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
    /// Converts a hex value to a SwiftUI `Color` type.
    /// - Parameters:
    ///   - hex: The hex value of the desired color in "0x00000" format.
    ///   - opacity: The desired SwiftUI Color output opacity. Defaults to 1.0.
    /// - Returns: The same color in sRGB/SwiftUI's Color type.
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
