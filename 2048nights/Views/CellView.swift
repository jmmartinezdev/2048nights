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
            .font(.system(size: getFontSize(), weight: .medium))
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
    
    func getFontSize() -> CGFloat {
        if model.value < 128 {
            return 55
        } else if model.value < 1024 {
            return 40
        } else if model.value <= 2048 {
            return 30
        } else {
            return 25
        }
    }
}
