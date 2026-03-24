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
            VStack(spacing: 8) {
                Text("Queens Remaining: \(viewModel.queensRemaining)")
                queenTray
                Text("Elapsed Time: \(GameTimeFormatter.hourMinuteSecond(from: viewModel.elapsedTime, decimals: 0))")
            }
            .zIndex(2)
            Spacer()
            boardView
                .disabled(viewModel.gameEnded)
                .zIndex(1)
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

    @State private var boardFrame: CGRect = .zero

    private struct BoardFrameKey: PreferenceKey {
        static var defaultValue: CGRect = .zero
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            value = nextValue()
        }
    }


    // MARK: - Child Views
    private var boardView: some View {
        GeometryReader { geo in
            let columns = Array(
                repeating: GridItem(.fixed(BoardUI.tileSize), spacing: 0),
                count: viewModel.boardSize
            )
            let rows = Array(
                repeating: GridItem(.fixed(BoardUI.tileSize), spacing: 0),
                count: viewModel.boardSize
            )

            let boardSizePx = CGFloat(viewModel.boardSize) * BoardUI.tileSize
            let originX = (geo.size.width - boardSizePx) / 2.0

            LazyVGrid(columns: columns, spacing: 0) {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .frame(height: boardSizePx)
            .frame(width: geo.size.width)
            .position(x: geo.size.width / 2.0, y: boardSizePx / 2.0)
            .background(
                GeometryReader { inner in
                    Color.clear
                        .preference(key: BoardFrameKey.self, value: CGRect(x: originX, y: 0, width: boardSizePx, height: boardSizePx))
                }
            )
        }
        .frame(height: CGFloat(viewModel.boardSize) * BoardUI.tileSize)
        .coordinateSpace(name: "boardSpace")
        .onPreferenceChange(BoardFrameKey.self) { frame in
            self.boardFrame = frame
        }
    }

    private var queenTray: some View {
        let count = viewModel.queensRemaining
        return HStack(spacing: 12) {
            ForEach(0..<count, id: \.self) { _ in
                DraggableQueenView { globalLocation in
                    // Map global location to board tile and attempt placement
                    guard boardFrame != .zero else { return false }
                    let x = globalLocation.x - boardFrame.minX
                    let y = globalLocation.y - boardFrame.minY
                    guard x >= 0, y >= 0, x < boardFrame.width, y < boardFrame.height else { return false }
                    let colIndex = Int(x / BoardUI.tileSize) + 1
                    let rowIndex = Int(y / BoardUI.tileSize) + 1
                    let position = Position(row: rowIndex, col: colIndex)
                    return viewModel.placeQueen(at: position)
                }
            }
        }
        .frame(height: 44)
        .padding(.vertical, 4)
        .zIndex(2)
    }

    private struct DraggableQueenView: View {
        var onDrop: (CGPoint) -> Bool
        @State private var offset: CGSize = .zero
        @State private var isDragging = false

        var body: some View {
            Image(Assets.blackQueen)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .scaleEffect(isDragging ? 1.2 : 1.0)
                .shadow(color: .black.opacity(isDragging ? 0.3 : 0.0), radius: 8, x: 0, y: 4)
                .offset(offset)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onChanged { value in
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                                isDragging = true
                            }
                            offset = value.translation
                        }
                        .onEnded { value in
                            let success = onDrop(value.location)
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                offset = .zero
                                isDragging = false
                            }
                            // success will reduce the tray count via view model state
                        }
                )
        }
    }
}

    
// MARK: - Preview
#Preview {
    GameView(boardSize: 4)
}
