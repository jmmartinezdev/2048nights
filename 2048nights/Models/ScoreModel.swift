//
//  ScoreModel.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import Combine
import Foundation

class ScoreModel: ObservableObject {
    @Published var score = 0
    
    func addScore(_ points: Int) {
        score = score + points
    }
    
    func updateHighScoreIfNeeded() {
        if getHighScore() < score {
            setHighScore(score)
        }
    }
    
    func getHighScore() -> Int {
        UserDefaults.standard.integer(forKey: "high_score")
    }
    
    func setHighScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: "high_score")
    }
}
