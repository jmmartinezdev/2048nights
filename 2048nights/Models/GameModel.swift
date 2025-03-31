//
//  GameModel.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import Combine

enum MoveDirection: CaseIterable {
    case up
    case left
    case right
    case down
}

class GameModel: ObservableObject {
    @Published var board: BoardModel
    @Published var score: ScoreModel
    @Published var hasWon: Bool
    @Published var gameOver: Bool
    @Published var continuePlaying: Bool
    
    init(boardSize: Int = 4) {
        self.board = BoardModel(size: boardSize)
        self.score = ScoreModel()
        self.hasWon = false
        self.gameOver = false
        self.continuePlaying = false
    }
    
    func resetGame() {
        board.resetBoard()
        score.resetScore()
        hasWon = false
        gameOver = false
        continuePlaying = false
    }
    
    func areMergesPossible() -> Bool {
        for row in 0..<board.size {
            for column in 0..<board.size {
                for direction in MoveDirection.allCases {
                    let cellValue = board.getValueFor(row, column)
                    let (vectorRow, vectorColumn) = getVector(direction: direction)
                    if board.isWithinBounds(row+vectorRow, column+vectorColumn) {
                        let nextValue = board.getValueFor(row+vectorRow, column+vectorColumn)
                        
                        if cellValue == nextValue {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func areMovesPossible() -> Bool {
        return board.emptyCellsAvailable() || areMergesPossible()
    }
    
    func getVector(direction: MoveDirection) -> (Int, Int) {
            switch direction {
            case .up:
                return (-1, 0)
            case .left:
                return (0, -1)
            case .right:
                return (0, 1)
            case .down:
                return (1, 0)
            }
    }
    
    func move(direction: MoveDirection) {
        var didMove = false
        
        board.prepareForMove()
        
//        let (vectorX, vectorY) = getVector(direction: direction)
        
        var (vectorX, vectorY): (Int, Int)
        var orderedRows: [Int]
        var orderedColumns: [Int]
        switch direction {
        case .up:
            (vectorX, vectorY) = (-1, 0)
            orderedRows = Array(0..<board.size)
            orderedColumns = Array(0..<board.size)
        case .left:
            (vectorX, vectorY) = (0, -1)
            orderedRows = Array(0..<board.size)
            orderedColumns = Array(0..<board.size)
        case .right:
            (vectorX, vectorY) = (0, 1)
            orderedRows = Array(0..<board.size)
            orderedColumns = Array(0..<board.size).reversed()
        case .down:
            (vectorX, vectorY) = (1, 0)
            orderedRows = Array(0..<board.size).reversed()
            orderedColumns = Array(0..<board.size)
        }
        print("Moving \(direction) (\(vectorX) \(vectorY)) \(orderedRows) \(orderedColumns)")
        
        orderedRows.forEach { row in 
            orderedColumns.forEach { column in
                guard !board.isCellAvailable(row, column) else {
                    return
                }
                let (nextRow, nextColumn) = findNearestValue(row: row, column: column, vectorX: vectorX, vectorY: vectorY)
                
                guard board.isWithinBounds(nextRow, nextColumn) else {
                    return
                }
                
                let currentValue = board.getValueFor(row, column)
                
                if (row != nextRow) || (column != nextColumn) {
                    board.setValue(row, column, 0)
                    board.setValue(nextRow, nextColumn, currentValue)
                    didMove = true
                }
                
                guard board.isWithinBounds(nextRow+vectorX, nextColumn+vectorY) else {
                    return
                }
                
                let nextValue = board.getValueFor(nextRow+vectorX, nextColumn+vectorY)
                if nextValue == currentValue,
                    !board.isMerged(nextRow+vectorX, nextColumn+vectorY) {
                    
                    board.setValue(nextRow+vectorX, nextColumn+vectorY, currentValue+nextValue)
                    board.setValue(nextRow, nextColumn, 0)
                    board.setIsMerged(nextRow+vectorX, nextColumn+vectorY, isMerged: true)
                    score.addScore(currentValue+nextValue)
                    if currentValue+nextValue == 2048 {
                        self.hasWon = true
                    }
                    didMove = true
                }
                
            }
        }
        
        if didMove {
            board.addNewValue()
            score.updateHighScoreIfNeeded()
            if !areMovesPossible() {
                gameOver = true
            }
        }
        
    }
    
    func findNearestValue(row: Int, column: Int, vectorX: Int, vectorY: Int) -> (Int, Int) {
        var (newRow, newColumn) = (row, column)
        var nearestValueFound = false
        while !nearestValueFound {
            (newRow, newColumn) = (newRow+vectorX, newColumn+vectorY)
            guard board.isWithinBounds(newRow, newColumn), 
                    board.isCellAvailable(newRow, newColumn) else {
                nearestValueFound = true
               return (newRow-vectorX, newColumn-vectorY)
            }
        }
        return (newRow-vectorX, newColumn-vectorY)
    }
}
