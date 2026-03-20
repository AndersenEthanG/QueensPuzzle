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
    @Binding var hasQueen: Bool
    var isDisabled: Bool = false

    let row: Int
    let col: Int


    // MARK: - Body
    var body: some View {
        Rectangle()
            .fill(fillColor())
            .frame(width: GlobalConstants.tileSize, height: GlobalConstants.tileSize)
            .overlay {
                if hasQueen {
                    Text(GlobalConstants.queenIcon)
                        .font(.system(size: GlobalConstants.tileSize))
                }
            }
            .onTapGesture {
                guard !isDisabled || hasQueen else { return }
                hasQueen.toggle()
            }
    }


    // MARK: - Computed Properties
    func fillColor() -> Color {
        if (row + col) % 2 == 0 {
            return GlobalConstants.lightColor
        } else {
            return GlobalConstants.darkColor
        }
    }
}


// MARK: - Preview
#Preview {
    @Previewable @State var hasQueen: Bool = false

    TileView(hasQueen: $hasQueen, row: 1, col: 1)
}
