//
//  TileView.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import SwiftUI


// MARK: - Tile View
struct TileView: View {

    // MARK: - Properties
    let tile: Tile
    let showHints: Bool
    let action: () -> Void


    // MARK: - Main Body
    var body: some View {
        Button(action: action) {
            Rectangle()
                .fill(tile.isLightSquare ? GlobalConstants.lightColor : GlobalConstants.darkColor)
                .frame(width: GlobalConstants.tileSize, height: GlobalConstants.tileSize)
                .overlay {
                    if showHints && tile.isConflicting {
                        Rectangle()
                            .fill(Color.red)
                            .opacity(0.5)
                    }
                }
                .overlay {
                    if tile.hasQueen {
                        Text(GlobalConstants.queenIcon)
                            .font(.title2)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Preview
#Preview {
    @Previewable @State var tile = Tile(position: Position(row: 1, col: 1))

    TileView(tile: tile, showHints: false) {
        print("")
    }
}
