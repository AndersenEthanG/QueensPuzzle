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
    @State private var board: [[Bool]] = []
    @State private var showingHints: Bool = false
    let nCount: Int


    // MARK: - Initializers
    init(nCount: Int) {
        self.nCount = nCount
    }


    // MARK: - Computed Properties
    private var queensPlaced: Int {
        board.flatMap { $0 }.filter { $0 }.count
    }

    private var queensRemaining: Int {
        max(0, nCount - queensPlaced)
    }

    private var isPlacementLocked: Bool {
        queensRemaining == 0
    }


    // MARK: - Main Body
    var body: some View {
        VStack(spacing: 48) {
            Text("Queens Remaining: \(queensRemaining)")
            Spacer()
            VStack(spacing: 0) {
                ForEach(0..<nCount, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<nCount, id: \.self) { col in
                            TileView(
                                hasQueen: bindingForTile(row: row, col: col), isDisabled: isPlacementLocked && !(board[safe: row]?[safe: col] ?? false), row: row,
                                col: col
                            )
                        }
                    }
                }
            }
            Button {
                showingHints.toggle()
            } label: {
                Text(showingHints ? "Hide Hints" : "Show Hints")
            }
            .buttonStyle(.borderedProminent)
            Spacer()
            Button {
                setupBoard()
            } label: {
                Text("Reset Board")
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(32)
        .onAppear {
            if board.count != nCount || board.contains(where: { $0.count != nCount }) {
                setupBoard()
            }
        }
    }


    // MARK: - Methods
    private func setupBoard() {
        board = Array(repeating: Array(repeating: false, count: nCount), count: nCount)
    }

    private func bindingForTile(row: Int, col: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                if let value = board[safe: row]?[safe: col] { return value }
                return false
            },
            set: { newValue in
                guard board.indices.contains(row), board[row].indices.contains(col) else { return }
                if isPlacementLocked && board[row][col] == false {
                    return
                }
                board[row][col] = newValue
            }
        )
    }
}


// MARK: - Preview
#Preview {
    GameView(nCount: 4)
}
