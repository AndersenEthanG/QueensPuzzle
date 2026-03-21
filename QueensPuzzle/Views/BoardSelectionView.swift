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
    @State var nCount: Int = 4


    // MARK: - Main Body
    var body: some View {
        VStack(spacing: 36) {
            Text("Queens Puzzle")
                .font(.title)
                .fontWeight(.bold)
            Stepper("Board Size: \(nCount)", value: $nCount, in: GlobalConstants.minBoardSize...GlobalConstants.maxBoardSize)
            Button {
                router.push(.game(nCount: nCount))
            } label: {
                Text("Start")
                    .font(.title2)
                    .padding(.horizontal, 32)
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(.all, 32)
    }
}


// MARK: - Preview
#Preview {
    @Previewable @StateObject var router = AppRouter()

    NavigationStack(path: $router.path) {
        BoardSelectionView()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .game(let nCount):
                    GameView(nCount: nCount)
                }
            }
            .environmentObject(router)
    }
}
