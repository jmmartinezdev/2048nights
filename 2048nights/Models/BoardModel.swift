//
//  BoardModel.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import Combine

class BoardModel: ObservableObject {
    let size: Int
    
    @Published var board: [RowModel]
    
    init(size: Int) {
        self.size = size
        self.board = []
        self.createRows()
        self.addNewValue()
        self.addNewValue()
        
    }
    
    private func createRows() {
        for i in 0..<size {
            board.append(RowModel(id: i, size: size))
        }
    }
    
    func getValueFor(_ row: Int, _ column: Int) -> Int {
        return board[row].getValue(position: column)
    }
    
    func setValue(_ row: Int, _ column: Int, _ value: Int) {
        print("setValue (\(row),\(column)) \(value)")
        board[row].cells[column].value = value
    }
    
    func isWithinBounds(_ row: Int, _ column: Int) -> Bool {
        return (row >= 0) && (row < size) && (column >= 0) && (column < size)
    }
    
    func emptyCellsAvailable() -> Bool {
        board.first { $0.cells.first { $0.value == 0 } != nil } != nil
    }
    
    func isCellAvailable(_ row: Int, _ column: Int) -> Bool {
        return getValueFor(row, column) == 0
    }
    
    func setIsMerged(_ row: Int, _ column: Int, isMerged: Bool) { 
        board[row].cells[column].isMerged = isMerged
    }
    
    func isMerged(_ row: Int, _ column: Int) -> Bool {
        return board[row].cells[column].isMerged
    }
    
    private func generateValue() -> Int {
        return Double.random(in: 0...1) > 0.9 ? 4 : 2
    }
    
    func addNewValue() {
        var valueAdded = false
        while !valueAdded {
            let row = Int.random(in: 0..<size)
            let column = Int.random(in: 0..<size)
            if isCellAvailable(row, column) {
                let value = generateValue()
                setValue(row, column, value)
                valueAdded = true
            }
        }
    }
    
    func resetBoard() {
        board.forEach({ $0.resetRow() })
        addNewValue()
        addNewValue()
    }
    
    func prepareForMove() {
        for i in 0..<size {
            for j in 0..<size {
                setIsMerged(i, j, isMerged: false)
            }
        }
    }
    
    func getFormattedValue(_ row: Int, _ column: Int) -> String {
        let value = getValueFor(row, column)
        if value == 0 {
            return "   -"
        } else if value < 10 {
            return "   \(value)"
        } else if value < 100 {
            return "  \(value)"
        } else if value < 1000 {
            return " \(value)"
        } else {
            return "\(value)"
        }
    }
    
    func getBoardString() -> String {
        var boardString = ""
        for i in 0..<size {
            for j in 0..<size {
                boardString.append(" \(getFormattedValue(i, j))")
            }
            boardString.append("\n")
        }
        boardString.append("\n")
        return boardString
    }
}
