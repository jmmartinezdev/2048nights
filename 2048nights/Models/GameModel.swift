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
    
    func getOrderedIndices(direction: MoveDirection) -> ([Int], [Int]) {
        var orderedRows: [Int]
        var orderedColumns: [Int]
        switch direction {
        case .up:
            orderedRows = Array(0..<board.size)
            orderedColumns = Array(0..<board.size)
        case .left:
            orderedRows = Array(0..<board.size)
            orderedColumns = Array(0..<board.size)
        case .right:
            orderedRows = Array(0..<board.size)
            orderedColumns = Array(0..<board.size).reversed()
        case .down:
            orderedRows = Array(0..<board.size).reversed()
            orderedColumns = Array(0..<board.size)
        }
        return (orderedRows, orderedColumns)
    }
    
    func move(direction: MoveDirection) {
        var didMove = false
        
        board.prepareForMove()
        
        let (vectorRow, vectorColumn) = getVector(direction: direction)
        let (orderedRows, orderedColumns) = getOrderedIndices(direction: direction)
        
        print("Moving \(direction) (\(vectorRow) \(vectorColumn)) \(orderedRows) \(orderedColumns)")
        
        orderedRows.forEach { row in 
            orderedColumns.forEach { column in
                guard !board.isCellAvailable(row, column) else {
                    return
                }
                let (nextRow, nextColumn) = findNearestValue(row, column, vectorRow, vectorColumn)
                
                guard board.isWithinBounds(nextRow, nextColumn) else {
                    return
                }
                
                let currentValue = board.getValueFor(row, column)
                
                if (row != nextRow) || (column != nextColumn) {
                    board.setValue(row, column, 0)
                    board.setValue(nextRow, nextColumn, currentValue)
                    didMove = true
                }
                
                guard board.isWithinBounds(nextRow+vectorRow, nextColumn+vectorColumn) else {
                    return
                }
                
                let nextValue = board.getValueFor(nextRow+vectorRow, nextColumn+vectorColumn)
                if nextValue == currentValue,
                    !board.isMerged(nextRow+vectorRow, nextColumn+vectorColumn) {
                    
                    let mergedValue = currentValue+nextValue
                    board.setValue(nextRow+vectorRow, nextColumn+vectorColumn, mergedValue)
                    board.setValue(nextRow, nextColumn, 0)
                    board.setIsMerged(nextRow+vectorRow, nextColumn+vectorColumn, isMerged: true)
                    score.addScore(mergedValue)
                    if mergedValue == 2048 {
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
    
    func findNearestValue(_ row: Int, _ column: Int, _ vectorX: Int, _ vectorY: Int) -> (Int, Int) {
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
