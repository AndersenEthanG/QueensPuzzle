//
//  GameViewModel.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation
import SwiftUI
import Combine


// MARK: - Game View Model
//@MainActor
//final class GameViewModel: ObservableObject {
//
//}

// MARK: - Position Model
// Keep Position globally available (Hashable) for Set membership and easy comparisons.
struct Position: Hashable {
    let row: Int
    let col: Int
}

struct Board {
    let size: Int
    var queens: Set<Position>
}
