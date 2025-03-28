//
//  BoardView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct BoardView: View {
    @ObservedObject var model: BoardModel
    
    var body: some View {
        VStack(spacing: 2) {
            ForEach(model.board, id: \.id) { rowModel in
                HStack(spacing: 2) {
                    ForEach(rowModel.cells, id: \.id) { cellModel in
                        CellView(model: cellModel)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .aspectRatio(1.0, contentMode: .fit)
    }
}
