//
//  ScoreContainerView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct ScoreContainerView: View {
    @ObservedObject var model: ScoreModel
    @AppStorage("high_score") var highScore = 0
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        if sizeCategory.isAccessibilityCategory {
            ScrollView(.horizontal) {
                HStack {
                    ScoreView(title: String(localized: "current_score"), score: model.score)
                    ScoreView(title: String(localized: "high_score"), score: highScore)
                }
                .padding()
            }
        } else {
            HStack {
                Spacer()
                ScoreView(title: String(localized: "current_score"), score: model.score)
                ScoreView(title: String(localized: "high_score"), score: highScore)
            }
            .padding()
        }
        }
        
}

#Preview {
    ScoreContainerView(model: ScoreModel())
}

fileprivate struct ScoreView: View {
    let title: String
    let score: Int
    
    var body: some View {
        VStack(content: {
            Text(title)
                .foregroundStyle(.scoreText)
            Text("\(score)")
                .font(.title)
                .foregroundStyle(.scoreText)
        })
        .padding()
        .background(Color.accentColor)
        .cornerRadius(8)
    }
    
}
