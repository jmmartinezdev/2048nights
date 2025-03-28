//
//  _048nightsApp.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

@main
struct _048nightsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: GameModel(board: BoardModel(size: 4)))
        }
    }
}
