//
//  QueensPuzzleApp.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/19/26.
//

import SwiftUI

// MARK: - Queens Puzzle App
@main
struct QueensPuzzleApp: App {

    // MARK: - Properties
    /// Modern SwiftUI navigation router tool.
    @StateObject private var router = AppRouter()
    
    private let bestTimeStore = BestTimeStore()


    // MARK: - Main Body
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                BoardSelectionView(bestTimeStore: bestTimeStore)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .game(let boardSize):
                            GameView(boardSize: boardSize, bestTimeStore: bestTimeStore)
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
