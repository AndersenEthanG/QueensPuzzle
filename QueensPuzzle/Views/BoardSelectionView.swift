//
//  BoardSelectionView.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import SwiftUI

// MARK: - Board Selection View
struct BoardSelectionView: View {

    // MARK: - Properties
    @EnvironmentObject private var router: AppRouter
    @State var boardSize: Int = 4
    let bestTimeStore: BestTimeStore
    let minBoardSize: Int = 4
    let maxBoardSize: Int = 16


    // MARK: - Main Body
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack {
                VStack(spacing: 36) {
                    Text("Queens Puzzle")
                        .font(.title)
                        .fontWeight(.bold)
                    Stepper("Board Size: \(boardSize)", value: $boardSize, in: minBoardSize...maxBoardSize)
                    Text("Best Time: \(bestTimeForBoardSize())")
                    Button {
                        router.push(.game(nCount: boardSize))
                    } label: {
                        Text("Start")
                            .font(.title2)
                            .padding(.horizontal, 32)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .glassEffect(in: .rect(cornerRadius: 20))
                .padding()
                Spacer()
            }
        }
    }


    // MARK: - Methods
    private func bestTimeForBoardSize() -> String {
        if let storedBestTime = bestTimeStore.bestTime(for: boardSize) {
            let formattedTime = GameTimeFormatter.hourMinuteSecond(from: storedBestTime, decimals: 2)
            return formattedTime
        } else {
            return "Set your first record!"
        }
    }
}


// MARK: - Preview
#Preview {
    @Previewable @StateObject var router = AppRouter()
    let bestTimeStore = BestTimeStore()

    NavigationStack(path: $router.path) {
        BoardSelectionView(bestTimeStore: bestTimeStore)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .game(let boardSize):
                    GameView(boardSize: boardSize, bestTimeStore: bestTimeStore)
                }
            }
            .environmentObject(router)
    }
}
