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
            ForEach(0..<model.board.count, id: \.self) { nRow in
                HStack(spacing: 8) {
                    ForEach(0..<model.board[nRow].count, id: \.self) { nColumn in
                        CellView(model: model.board[nRow][nColumn])
                            .background(.cellBackgroundEmpty)
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
