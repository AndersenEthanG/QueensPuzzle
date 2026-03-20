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
    @StateObject private var router = AppRouter()


    // MARK: - Main Body
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                BoardSelectionView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .game(let nCount):
                            GameView(nCount: nCount)
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
