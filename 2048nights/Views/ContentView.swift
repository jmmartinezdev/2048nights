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
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global).onEnded({ value in
                let horizontalMovement = value.translation.width
                let verticalMovement = value.translation.height
                    
                if abs(horizontalMovement) > abs(verticalMovement) {
                    if horizontalMovement < 0 {
                        model.move(direction: .left)
                    } else {
                        model.move(direction: .right)
                    }
                } else {
                    if horizontalMovement < 0 {
                        model.move(direction: .up)
                    } else {
                        model.move(direction: .down)
                    }
                }
            }))
        
        ArrowButtonsView { direction in
            model.move(direction: direction)
        }
    }
}

#Preview {
    ContentView(model: GameModel(boardSize: 4))
}
