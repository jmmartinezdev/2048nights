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

        Color.contentBackground
            .ignoresSafeArea()
            .overlay {
                VStack {
                    HStack {
                        Spacer()

                        Button(action: {
                            model.resetGame()
                        }) {
                            Text("restart_game")
                                .font(.headline)
                                .padding()
                                .background(.buttonBackground)
                                .cornerRadius(8)
                        }
                    }.padding()

                    ScoreView(model: model.score)

                    BoardView(model: model.board)
                        .padding()
                        .gesture(
                            DragGesture(
                                minimumDistance: 20, coordinateSpace: .global
                            ).onEnded({ value in
                                let horizontalMovement = value.translation.width
                                let verticalMovement = value.translation.height

                                if abs(horizontalMovement)
                                    > abs(verticalMovement)
                                {
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

#Preview {
    ContentView(model: GameModel(boardSize: 4))
}
