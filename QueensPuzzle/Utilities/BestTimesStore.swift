//
//  BestTimesStore.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation

// MARK: - Protocols
protocol BestTimeStoring {
    func bestTime(for boardSize: Int) -> TimeInterval?
    func saveBestTime(_ time: TimeInterval, for boardSize: Int)
}


// MARK: - Best Times Store
/*
final class BestTimeStore: BestTimeStoring {
    func bestTime(for boardSize: Int) -> TimeInterval? {
        <#code#>
    }
    
    func saveBestTime(_ time: TimeInterval, for boardSize: Int) {
        <#code#>
    }
    
    // UserDefaults implementation
}
*/
