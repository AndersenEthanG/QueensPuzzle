//
//  NavigationHelper.swift
//  QueensPuzzle
//
//  Created by Ethan Andersen on 3/20/26.
//

import Foundation
import Combine


// MARK: - Navigation Route
enum Route: Hashable {
    case game(nCount: Int)
}


// MARK: - AppRouter
@MainActor
final class AppRouter: ObservableObject {
    @Published var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func popCurrent() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
