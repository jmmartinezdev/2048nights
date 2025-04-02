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
                // Skip if cell is empty
                guard !board.isCellAvailable(row, column) else {
                    return
                }
                
                // Find furthest adjacent empty cell
                let (newRow, newColumn) = findFurthestEmptyCell(row, column, vectorRow, vectorColumn)
                
                guard board.isWithinBounds(newRow, newColumn) else {
                    print("1. Out of bounds \(newRow) \(newColumn)")
                    return
                }
                
                let currentValue = board.getValueFor(row, column)
                
                // If the new position is different, move to it
                if (row != newRow) || (column != newColumn) {
                    print("Moving \(row) \(column) to \(newRow) \(newColumn): \(currentValue)")
                    board.setValue(row, column, 0)
                    board.setValue(newRow, newColumn, currentValue)
                    didMove = true
                }
                
                // Evaluate next row if within bounds
                let (nextRow, nextColumn) = (newRow+vectorRow, newColumn+vectorColumn)
                guard board.isWithinBounds(nextRow, nextColumn) else {
                    print("2. Out of bounds \(nextRow) \(nextColumn)")
                    return
                }
                
                // If the value is the same and isn't previously merged, we merge into the next cell
                let nextValue = board.getValueFor(nextRow, nextColumn)
                if nextValue == currentValue, !board.isMerged(nextRow, nextColumn) {
                    
                    let mergedValue = currentValue+nextValue
                    print("Merging \(newRow) \(newColumn) into \(nextRow) \(nextColumn): \(mergedValue)")
                    board.setValue(nextRow, nextColumn, mergedValue)
                    board.setValue(newRow, newColumn, 0)
                    board.setIsMerged(nextRow, nextColumn, isMerged: true)
                    score.addScore(mergedValue)
                    if mergedValue == 2048 {
                        self.hasWon = true
                    }
                    didMove = true
                }
                
            }
        }
        
        if didMove {
            board.addNewRandomValue()
            score.updateHighScoreIfNeeded()
            if !areMovesPossible() {
                gameOver = true
            }
        }
        
    }
    
    func findFurthestEmptyCell(_ currentRow: Int, _ currentColumn: Int, _ vectorRow: Int, _ vectorColumn: Int) -> (Int, Int) {
        var (row, column) = (currentRow, currentColumn)
        var (nextRow, nextColumn) = (row+vectorRow, column+vectorColumn)
        while board.isWithinBounds(nextRow, nextColumn) && board.isCellAvailable(nextRow, nextColumn) {
            (row, column) = (nextRow, nextColumn)
            (nextRow, nextColumn) = (row+vectorRow, column+vectorColumn)
        }
        return (row, column)
    }
}
