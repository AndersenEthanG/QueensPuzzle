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
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel: GameViewModel


    // MARK: - Initializers
    init(boardSize: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(boardSize: boardSize))
    }


    // MARK: - Main Body
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack {
                VStack(spacing: 64) {
                    VStack(spacing: 16) {
                        ZStack {
                            HStack {
                                Button {
                                    router.popCurrent()
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.title2)
                                }
                                .buttonStyle(.plain)
                                .padding(10)
                                .glassEffect(in: .circle)
                                Spacer()
                            }
                            Text("Puzzle Size: \(viewModel.boardSize)x\(viewModel.boardSize)")
                                .font(.title2.weight(.semibold))
                        }
                        Text("Queens Remaining: \(viewModel.queensRemaining)")
                            .font(.headline)
                        Text("Elapsed Time: \(GameTimeFormatter.hourMinuteSecond(from: viewModel.elapsedTime, decimals: 0))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    boardView
                        .disabled(viewModel.gameEnded)
                    VStack(spacing: 16) {
                        Button {
                            viewModel.toggleHints()
                        } label: {
                            Text(viewModel.showHints ? "Hide Hints" : "Show Hints")
                                .frame(minWidth: 120)
                        }
                        .buttonStyle(.glassProminent)
                        .controlSize(.large)
                        .padding()
                        Button {
                            viewModel.resetGame()
                        } label: {
                            Text("Reset Board")
                                .frame(minWidth: 120)
                        }
                        .buttonStyle(.glassProminent)
                        .controlSize(.large)
                    }
                }
                .padding()
                .glassEffect(in: .rect(cornerRadius: 20))
                .padding()
                Spacer()
            }
            if viewModel.showWinScreen {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    winScreen
                        .padding(.horizontal, 24)
                        .padding(.bottom, 120)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .animation(.bouncy(duration: 0.4), value: viewModel.showWinScreen)
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

    private var winScreen: some View {
        GlassEffectContainer {
            VStack(spacing: 10) {
                Text("You Win!")
                    .font(.title.weight(.semibold))
                Text("Your time: \(GameTimeFormatter.hourMinuteSecond(from: viewModel.elapsedTime, decimals: 2))")
                    .font(.headline)
                if let bestTime = viewModel.bestTime {
                    Text("Best time: \(GameTimeFormatter.hourMinuteSecond(from: bestTime, decimals: 2))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Button {
                    viewModel.showWinScreen = false
                } label: {
                    Text("Continue")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.horizontal, 48)
                }
                .buttonStyle(.borderedProminent)
                .glassEffect(.regular.interactive())
                .padding(.top)
            }
            .padding(32)
            .glassEffect(in: .rect(cornerRadius: 32))
        }
    }
}


// MARK: - Preview
#Preview {
    GameView(boardSize: 4)
}
