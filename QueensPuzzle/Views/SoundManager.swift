import Foundation
import AVFoundation

enum SoundEffect: String, CaseIterable {
    case toggle
    case place
    case remove
    case reset
    case win

    var fileName: String {
        switch self {
        case .toggle: return "toggle"
        case .place: return "place"
        case .remove: return "remove"
        case .reset: return "reset"
        case .win: return "win"
        }
    }

    var fileExtension: String { "mp3" } // Change to match your assets
}

final class SoundManager {
    static let shared = SoundManager()

    private var players: [SoundEffect: AVAudioPlayer] = [:]
    private var audioSessionConfigured = false

    private init() {}

    func play(_ effect: SoundEffect, volume: Float = 1.0) {
        configureSessionIfNeeded()
        if let player = players[effect] {
            player.currentTime = 0
            player.volume = volume
            player.play()
            return
        }

        guard let url = Bundle.main.url(forResource: effect.fileName, withExtension: effect.fileExtension) else {
            // Missing asset; silently ignore in development
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.volume = volume
            players[effect] = player
            player.play()
        } catch {
            // Ignore for now; could log in future
        }
    }

    private func configureSessionIfNeeded() {
        guard !audioSessionConfigured else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            audioSessionConfigured = true
        } catch {
            // Ignore configuration failure
        }
    }
}
