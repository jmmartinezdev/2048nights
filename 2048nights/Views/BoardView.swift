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
        VStack(spacing: 8) {
            ForEach(model.board, id: \.id) { rowModel in
                HStack(spacing: 8) {
                    ForEach(rowModel.cells, id: \.id) { cellModel in
                        CellView(model: cellModel)
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.boardLines)
        .aspectRatio(1.0, contentMode: .fit)
        .cornerRadius(8)
    }
}
