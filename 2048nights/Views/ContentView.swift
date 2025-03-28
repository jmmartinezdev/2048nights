//
//  ContentView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: GameModel
    
    var body: some View {
        
        ScoreView(model: model.score)
        
        BoardView(model: model.board)
            .padding()
        
        ArrowButtonsView { direction in
            model.move(direction: direction)
        }
    }
}

#Preview {
    ContentView(model: GameModel(boardSize: 4))
}
