import SwiftUI
import UIKit


// MARK: - Victory View
struct VictoryView: View {
    let elapsedTime: TimeInterval
    let bestTime: TimeInterval?
    let boardSize: Int
    let onPlayAgain: () -> Void
    let onBackToMenu: () -> Void

    @State private var showConfetti: Bool = true

    var body: some View {
        ZStack {
            // Background gradient consistent with GameView style
            LinearGradient(
                colors: [Color.blue, Color.indigo],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Background blur card
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(.white.opacity(0.25), lineWidth: 1)
                )
                .padding()

            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill").foregroundStyle(.yellow)
                    Text("Checkmate!")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                Text("You solved the \(boardSize)×\(boardSize) board")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))

                // Time summary
                VStack(spacing: 8) {
                    Text("Time: \(GameTimeFormatter.hourMinuteSecond(from: elapsedTime, decimals: 2))")
                        .font(.title3.monospacedDigit())
                        .foregroundStyle(.white)
                    if let best = bestTime {
                        Text("Best: \(GameTimeFormatter.hourMinuteSecond(from: best, decimals: 2))")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.thinMaterial)
                )

                // Actions
                HStack(spacing: 12) {
                    Button {
                        onPlayAgain()
                    } label: {
                        Label("Play Again", systemImage: "arrow.clockwise.circle.fill")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(BoardUI.accent)

                    Button {
                        onBackToMenu()
                    } label: {
                        Label("Back to Menu", systemImage: "house.fill")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 8)

                Spacer(minLength: 0)
            }
            .padding(24)

            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
                    .transition(.opacity)
                    .onAppear {
                        // Auto-stop confetti after 2.5s
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation { showConfetti = false }
                        }
                    }
            }
        }
        .padding(16)
    }
}

// MARK: - Confetti View
struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: -10)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: 1)

        let colors: [UIColor] = [
            UIColor.systemPink,
            UIColor.systemYellow,
            UIColor.systemGreen,
            UIColor.systemBlue,
            UIColor.systemOrange,
            UIColor.systemPurple
        ]

        let cells: [CAEmitterCell] = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 6
            cell.lifetime = 6
            cell.lifetimeRange = 2
            cell.velocity = 180
            cell.velocityRange = 80
            cell.emissionLongitude = .pi
            cell.emissionRange = .pi / 8
            cell.spin = 3
            cell.spinRange = 2
            cell.scale = 0.6
            cell.scaleRange = 0.3
            cell.color = color.cgColor
            cell.contents = UIImage(systemName: "circle.fill")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 10))
                .cgImage
            return cell
        }

        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)

        // Stop emission after a short burst
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            emitter.birthRate = 0
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - Preview
#Preview {
    VictoryView(
        elapsedTime: 12.34,
        bestTime: 11.11,
        boardSize: 4,
        onPlayAgain: {},
        onBackToMenu: {}
    )
    .ignoresSafeArea()
}
