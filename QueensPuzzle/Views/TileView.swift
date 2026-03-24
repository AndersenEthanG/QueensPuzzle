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
    let tileSize: CGFloat
    let action: () -> Void


    // MARK: - Main Body
    var body: some View {
        Button(action: action) {
            Rectangle()
                .fill(tile.isLightSquare ? BoardUI.lightSquareColor : BoardUI.darkSquareColor)
                .frame(width: tileSize, height: tileSize)
                .overlay {
                    if showHints && tile.isThreatened {
                        Rectangle()
                            .fill(Color.red.opacity(0.75))
                    }
                }
                .overlay {
                    if tile.hasQueen {
                        Image(Assets.blackQueen)
                            .resizable()
                            .scaledToFit()
                            .padding(tileSize * 0.12)
                    }
                }
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Preview
#Preview {
    @Previewable @State var tile = Tile(position: Position(row: 1, col: 1))

    TileView(tile: tile, showHints: false, tileSize: 16) {
        print("")
    }
}
