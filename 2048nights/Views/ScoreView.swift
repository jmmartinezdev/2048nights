//
//  ScoreView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct ScoreView: View {
    @ObservedObject var model: ScoreModel
    @AppStorage("high_score") var highScore = 0
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(content: {
                Text("current_score")
                Text("\(model.score)")
                    .font(.title)
            })
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
            
            VStack(content: {
                Text("high_score")
                Text("\(highScore)")
                    .font(.title)
            })
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
        }.padding()
    }
}

#Preview {
    ScoreView(model: ScoreModel())
}
