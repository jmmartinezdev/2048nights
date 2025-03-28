//
//  ScoreView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct ScoreView: View {
    @ObservedObject var model: GameModel
    
    var body: some View {
        VStack(content: {
            Text("Score")
            Text("\(model.score)")
                .font(.title)
        })
        .padding()
        .background(Color.accentColor)
    }
}

#Preview {
    ScoreView(model: GameModel(board: BoardModel(size: 4)))
}
