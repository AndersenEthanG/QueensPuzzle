//
//  ContentView.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/19/26.
//

import SwiftUI

// MARK: - Game View
struct GameView: View {

    // MARK: - Properties
    @StateObject private var viewModel: GameViewModel


    // MARK: - Initializers
    init(boardSize: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(boardSize: boardSize))
    }


    // MARK: - Main Body
    var body: some View {
        VStack(spacing: 36) {
            Text("Queens Remaining: \(viewModel.queensRemaining)")
            Text("Elapsed Time: \(GameTimeFormatter.hourMinuteSecond(from: viewModel.elapsedTime, decimals: 0))")
            Spacer()
            boardView
                .disabled(viewModel.gameEnded)
            Button {
                viewModel.toggleHints()
            } label: {
                Text(viewModel.showHints ? "Hide Hints" : "Show Hints")
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Button {
                viewModel.resetGame()
            } label: {
                Text("Reset Board")
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(32)
        .navigationTitle("\(viewModel.boardSize)x\(viewModel.boardSize)")
        .alert("You Win!\nYour time was \(GameTimeFormatter.hourMinuteSecond(from: viewModel.elapsedTime, decimals: 2))", isPresented: $viewModel.showWinScreen) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            viewModel.startGame()
        }
    }


    // MARK: - Child Views
    private var boardView: some View {
        let columns = Array(
            repeating: GridItem(.fixed(BoardUI.tileSize), spacing: 0),
            count: viewModel.boardSize
        )
        let rows = Array(
            repeating: GridItem(.fixed(BoardUI.tileSize), spacing: 0),
            count: viewModel.boardSize
        )

        return LazyVGrid(columns: columns, spacing: 0) {
            ForEach(1...viewModel.boardSize, id: \.self) { row in
                LazyHGrid(rows: rows) {
                    ForEach(1...viewModel.boardSize, id: \.self) { col in
                        let position = Position(row: row, col: col)

                        TileView(
                            tile: viewModel.tile(at: position),
                            showHints: viewModel.showHints
                        ) {
                            viewModel.userTapped(at: position)
                        }
                    }
                }
            }
        }
    }
}


// MARK: - Preview
#Preview {
    GameView(boardSize: 4)
}
