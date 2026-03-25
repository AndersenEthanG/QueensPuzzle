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
    let bestTimeStore: BestTimeStore


    // MARK: - Initializers
    init(boardSize: Int, bestTimeStore: BestTimeStore) {
        _viewModel = StateObject(wrappedValue: GameViewModel(boardSize: boardSize, bestTimeStore: bestTimeStore))
        self.bestTimeStore = bestTimeStore
    }


    // MARK: - Main Body
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack {
                VStack(spacing: 64) {
                    headerView
                    boardContainerView
                    controlsView
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
    private var headerView: some View {
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
    }

    private var boardContainerView: some View {
        GeometryReader { geometry in
            let sideLength = min(geometry.size.width, geometry.size.height)
            let tileSize = sideLength / CGFloat(viewModel.boardSize)

            boardView(tileSize: tileSize)
                .frame(width: sideLength, height: sideLength)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
        .disabled(viewModel.gameEnded)
    }

    private func boardView(tileSize: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach(1...viewModel.boardSize, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(1...viewModel.boardSize, id: \.self) { col in
                        let position = Position(row: row, col: col)
                        
                        TileView(
                            tile: viewModel.tile(at: position),
                            showHints: viewModel.showHints,
                            tileSize: tileSize
                        ) {
                            viewModel.userTapped(at: position)
                        }
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var controlsView: some View {
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

    private var winScreen: some View {
        let elapsedTime = viewModel.elapsedTime

        return GlassEffectContainer {
            VStack(spacing: 12) {
                Text("You Win!")
                    .font(.title.weight(.semibold))
                Text("Your time: \(GameTimeFormatter.hourMinuteSecond(from: elapsedTime, decimals: 2))")
                    .font(.headline)
                if let bestTime = viewModel.bestTime {
                    if bestTime == elapsedTime {
                        Text("New best time!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Best time: \(GameTimeFormatter.hourMinuteSecond(from: bestTime, decimals: 2))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Button {
                    viewModel.showWinScreen = false
                } label: {
                    Text("View Solution")
                        .font(.title3)
                        .fontWeight(.medium)
                        .frame(minWidth: 180)
                }
                .buttonStyle(.bordered)
                .glassEffect(.regular.interactive())
                .padding(.top)
                Button {
                    viewModel.showWinScreen = false
                    router.popToRoot()
                } label: {
                    Text("Menu")
                        .font(.title3)
                        .fontWeight(.medium)
                        .frame(minWidth: 180)
                }
                .buttonStyle(.borderedProminent)
                .glassEffect(.regular.interactive())
            }
            .padding(32)
            .glassEffect(in: .rect(cornerRadius: 32))
        }
    }
}


// MARK: - Preview
#Preview {
    GameView(boardSize: 4, bestTimeStore: BestTimeStore())
}
