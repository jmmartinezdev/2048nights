//
//  GameModel.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import Combine

enum MoveDirection {
    case up
    case left
    case right
    case down
}

class GameModel: ObservableObject {
    @Published var board: BoardModel
    @Published var score: ScoreModel
    
    init(boardSize: Int) {
        self.board = BoardModel(size: boardSize)
        self.score = ScoreModel()
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
        
        for i in 0..<board.size {
            for j in 0..<board.size {
                board.setIsMerged(i, j, isMerged: false)
            }
        }
        
//        let (vectorX, vectorY) = getVector(direction: direction)
        
        var (vectorX, vectorY): (Int, Int)
        var rows: [Int]
        var columns: [Int]
        switch direction {
        case .up:
            (vectorX, vectorY) = (-1, 0)
            rows = Array(0..<board.size)
            columns = Array(0..<board.size)
        case .left:
            (vectorX, vectorY) = (0, -1)
            rows = Array(0..<board.size)
            columns = Array(0..<board.size)
        case .right:
            (vectorX, vectorY) = (0, 1)
            rows = Array(0..<board.size)
            columns = Array(0..<board.size).reversed()
        case .down:
            (vectorX, vectorY) = (1, 0)
            rows = Array(0..<board.size).reversed()
            columns = Array(0..<board.size)
        }
        print("Moving \(direction) (\(vectorX) \(vectorY)) \(rows) \(columns)")
        print(board.getBoardString())
        
        rows.forEach { row in 
            columns.forEach { column in
//                let nextRow = row + vectorX
//                let nextColumn = column + vectorY
                guard !board.isCellAvailable(row, column) else {
                    return
                }
                print("r:\(row) c:\(column)")
                let (nextRow, nextColumn) = findNearestValue(row: row, column: column, vectorX: vectorX, vectorY: vectorY)
                print("nr:\(nextRow) nc:\(nextColumn)")
                
                guard board.isWithinBounds(nextRow, nextColumn) else {
                    return
                }
                
                let currentValue = board.getValueFor(row, column)
                
                if (row != nextRow) || (column != nextColumn) {
                    board.setValue(row, column, 0)
                    board.setValue(nextRow, nextColumn, currentValue)
                    didMove = true
                    print(board.getBoardString())
                }
                
                guard board.isWithinBounds(nextRow+vectorX, nextColumn+vectorY) else {
                    return
                }
                
                let nextValue = board.getValueFor(nextRow+vectorX, nextColumn+vectorY)
                if nextValue == currentValue, 
                    !board.isMerged(nextRow+vectorX, nextColumn+vectorY) {
                    
                    print("Merge a:(\(nextRow), \(nextColumn)), b:(\(nextRow+vectorX), \(nextColumn+vectorY))")
                    board.setValue(nextRow+vectorX, nextColumn+vectorY, currentValue+nextValue)
                    print(board.getBoardString())
                    board.setValue(nextRow, nextColumn, 0)
                    print(board.getBoardString())
                    board.setIsMerged(nextRow+vectorX, nextColumn+vectorY, isMerged: true)
                    score.addScore(currentValue+nextValue)
                    didMove = true
                }
                
            }
        }
        
        if didMove {
            board.addNewValue()
            print(board.getBoardString())
        }
        
        score.updateHighScoreIfNeeded()
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
