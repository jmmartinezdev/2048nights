//
//  ContentView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: GameModel
    @FocusState private var isFocused: Bool

    var body: some View {

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
                                computeGesture(
                                    value.translation.width,
                                    value.translation.height)
                            })
                        )
                        .focusable()
                        .focused($isFocused)
                        .onKeyPress(
                            keys: [
                                .upArrow, .downArrow, .leftArrow, .rightArrow,
                            ],
                            action: { keyPress in
                                processKeyboard(keyPress)
                                return .handled
                            }
                        )
                        .onAppear(perform: {
                            isFocused = true
                        })
                        .overlay {
                            if model.gameOver {
                                GameOverMessageView {
                                    model.resetGame()
                                }
                            }
                        }
                        .overlay {
                            if model.hasWon && !model.continuePlaying {
                                WinMessageView {
                                    model.resetGame()
                                } continueAction: {
                                    model.continuePlaying = true
                                }
                            }
                        }

//                        ArrowButtonsView { direction in
//                            model.move(direction: direction)
//                        }
                }
            }
    }
    
    func processKeyboard(_ keyPress: KeyPress) {
        Task { @MainActor in
            if keyPress.key == .upArrow {
                model.move(direction: .up)
            } else if keyPress.key == .downArrow {
                model.move(direction: .down)
            } else if keyPress.key == .leftArrow {
                model.move(direction: .left)
            } else if keyPress.key == .rightArrow {
                model.move(direction: .right)
            }
        }
    }

    func computeGesture(
        _ horizontalMovement: Double, _ verticalMovement: Double
    ) {
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
