//
//  CellView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct CellView: View {
    @ObservedObject var model: CellModel
    
    var body: some View {
        Text(model.getValueText())
            .font(.title)
            .frame(minWidth: 72, maxWidth: .infinity, minHeight: 72, maxHeight: .infinity)
            .foregroundStyle(.cellText)
            .background(model.getBackgroundColor())
            .aspectRatio(1.0, contentMode: .fit)
            .lineLimit(1)
            .cornerRadius(8)
            .accessibilityShowsLargeContentViewer {
                Text(model.getValueTextForLargeContentViewer())
            }
    }
}
