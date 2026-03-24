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
    @EnvironmentObject private var router: AppRouter

    // MARK: - Initializers
    init(boardSize: Int) {
        _viewModel = StateObject(wrappedValue: GameViewModel(boardSize: boardSize))
    }

    // MARK: - Main Body
    var body: some View {
        ZStack {
            LinearGradient(colors: [BoardUI.backgroundTop, BoardUI.backgroundBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                VStack(spacing: 4) {
                    Text("Queens Puzzle")
                        .font(.largeTitle).fontWeight(.bold)
                        .foregroundStyle(.white)
                        .shadow(radius: 8)
                    Text("\(viewModel.boardSize)x\(viewModel.boardSize)")
                        .font(.title3).fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(.top, 8)

                // Score Bar
                HStack(spacing: 16) {
                    Label { Text("Queens Remaining") } icon: { Image(systemName: "crown.fill") }
                        .font(.caption).foregroundStyle(.white.opacity(0.8))
                        .labelStyle(.iconOnly)
                    Text("\(viewModel.queensRemaining)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(minWidth: 64)
                        .contentTransition(.numericText(value: Double(viewModel.queensRemaining)))
                    Spacer(minLength: 16)
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Elapsed Time")
                            .font(.caption).foregroundStyle(.white.opacity(0.8))
                        Text(GameTimeFormatter.hourMinuteSecond(from: viewModel.elapsedTime, decimals: 0))
                            .font(.title2.monospacedDigit()).fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                }
                .padding(16)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                )

                // Board
                boardView
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 8)
                    .disabled(viewModel.gameEnded)

                // Controls
                HStack(spacing: 12) {
                    Button {
                        viewModel.toggleHints()
                        SoundManager.shared.play(.toggle)
                    } label: {
                        Label(viewModel.showHints ? "Hide Hints" : "Show Hints", systemImage: viewModel.showHints ? "eye.slash.fill" : "eye.fill")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(BoardUI.accent)

                    Button(role: .destructive) {
                        viewModel.resetGame()
                        SoundManager.shared.play(.reset)
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.bordered)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .sheet(isPresented: $viewModel.showWinScreen) {
            VictoryView(
                elapsedTime: viewModel.elapsedTime,
                bestTime: viewModel.bestTime,
                boardSize: viewModel.boardSize,
                onPlayAgain: {
                    viewModel.resetGame()
                    viewModel.startGame()
                },
                onBackToMenu: {
                    router.popToRoot()
                }
            )
            .presentationDetents([.fraction(0.6)])
            .presentationDragIndicator(.visible)
            .background(
                LinearGradient(colors: [BoardUI.backgroundTop, BoardUI.backgroundBottom], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
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
