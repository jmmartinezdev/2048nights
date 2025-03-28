//
//  RowModel.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//


class RowModel {
    let id: Int
    var cells: [CellModel]
    
    init(id: Int, size: Int) {
        self.id = id
        self.cells = []
        self.createCells(size: size)
    }
    
    func createCells(size: Int) {
        for i in 0..<size {
            cells.append(CellModel(id: i))
        }
    }
    
    func getValue(position: Int) -> Int {
        return cells[position].value
    }
}
