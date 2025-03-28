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

        NavigationView {
            Color.contentBackground
                .ignoresSafeArea()
                .overlay {
                    VStack {
                        RestartGameView {
                            model.resetGame()
                        }

                        ScoreView(model: model.score)

                        BoardView(model: model.board)
                            .padding()
                            .gesture(
                                DragGesture(
                                    minimumDistance: 20, coordinateSpace: .global
                                ).onEnded({ value in
                                    computeGesture(value.translation.width, value.translation.height)
                                }))

                        if model.hasWon {
                            Text("you_won")
                                .font(.largeTitle)
                        }

                        //        ArrowButtonsView { direction in
                        //            model.move(direction: direction)
                        //        }
                    }
                }
        }
    }
    
    func computeGesture(_ horizontalMovement: Double, _ verticalMovement: Double) {
        if abs(horizontalMovement) > abs(verticalMovement) {
            if horizontalMovement < 0 {
                model.move(direction: .left)
            } else {
                model.move(direction: .right)
            }
        } else {
            if verticalMovement < 0 {
                model.move(direction: .up)
            } else {
                model.move(direction: .down)
            }
        }
    }

}

#Preview {
    ContentView(model: GameModel(boardSize: 4))
}
