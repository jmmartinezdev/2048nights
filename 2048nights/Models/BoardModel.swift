//
//  BoardModel.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import Combine

class BoardModel: ObservableObject {
    let size: Int
    let startingCells = 2
    
    @Published var board: [[CellModel]]
    
    init(size: Int = 4) {
        self.size = size
        self.board = []
        self.createRows()
        for _ in 0..<startingCells {
            self.addNewRandomValue()
        }
        
    }
    
    private func createRows() {
        for _ in 0..<size {
            var row: [CellModel] = []
            for j in 0..<size {
                row.append(CellModel(id: j))
            }
            board.append(row)
        }
    }
    
    private func getCellFor(_ row: Int, _ column: Int) -> CellModel {
        board[row][column]
    }
    
    func getValueFor(_ row: Int, _ column: Int) -> Int {
        return getCellFor(row, column).value
    }
    
    func setValue(_ row: Int, _ column: Int, _ value: Int) {
        getCellFor(row, column).value = value
    }
    
    func isWithinBounds(_ row: Int, _ column: Int) -> Bool {
        return (row >= 0) && (row < size) && (column >= 0) && (column < size)
    }
    
    func emptyCellsAvailable() -> Bool {
        board.first { $0.first { $0.value == 0 } != nil } != nil
    }
    
    func isCellAvailable(_ row: Int, _ column: Int) -> Bool {
        return getValueFor(row, column) == 0
    }
    
    func setIsMerged(_ row: Int, _ column: Int, isMerged: Bool) { 
        getCellFor(row, column).isMerged = isMerged
    }
    
    func isMerged(_ row: Int, _ column: Int) -> Bool {
        return getCellFor(row, column).isMerged
    }
    
    private func generateValue() -> Int {
        return Double.random(in: 0...1) > 0.9 ? 4 : 2
    }
    
    func addNewRandomValue() {
        var valueAdded = false
        while !valueAdded {
            let row = Int.random(in: 0..<size)
            let column = Int.random(in: 0..<size)
            if isCellAvailable(row, column) {
                let value = generateValue()
                setValue(row, column, value)
                getCellFor(row, column).newlyAdded = true
                print("New value added \(row) \(column) : \(value)")
                valueAdded = true
            }
        }
    }
    
    func resetBoard() {
        board.forEach({ $0.forEach({ $0.resetCell() }) })
        for _ in 0..<startingCells {
            addNewRandomValue()
        }
    }
    
    func prepareForMove() {
        for i in 0..<size {
            for j in 0..<size {
                setIsMerged(i, j, isMerged: false)
                getCellFor(i, j).newlyAdded = false
            }
        }
    }
}

// MARK: Extension for testing
extension BoardModel {
    
    convenience init(size: Int = 4, board: [[Int]]) {
        self.init(size: 4)
        self.board = []
        self.createRows(boardNumbers: board)
        for _ in 0..<startingCells {
            self.addNewRandomValue()
        }
        
    }
    
    private func createRows(boardNumbers: [[Int]]) {
        for i in 0..<size {
            var row: [CellModel] = []
            for j in 0..<size {
                let cell = CellModel(id: j)
                cell.value = boardNumbers[i][j]
                row.append(cell)
            }
            board.append(row)
        }
    }
    
    static let exampleBoard = [
        [2, 0, 0, 0],
        [2, 4, 8, 16],
        [32, 64, 128, 256],
        [4096, 2048, 1024, 512],
    ]
}
