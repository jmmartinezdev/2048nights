//
//  CellView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct CellView: View {
    @ObservedObject var model: CellModel
    @State var justMerged: Bool = false
    @State var justAdded: Bool = false
    
    var body: some View {
        Text(model.getValueText())
            .font(.system(size: getFontSize(), weight: .medium))
            .frame(minWidth: 72, maxWidth: .infinity, minHeight: 72, maxHeight: .infinity)
            .foregroundStyle(.cellText)
            .scaleEffect(justAdded ? 0.5 : 1)
            .opacity(justAdded ? 0 : 1)
            .animation(.easeInOut(duration: 0.05), value: justAdded)
            .onReceive(model.$newlyAdded) { newlyAdded in
                if newlyAdded {
                    justAdded = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        justAdded = false
                    }
                }
            }
            .background(model.getBackgroundColor())
            .aspectRatio(1.0, contentMode: .fit)
            .lineLimit(1)
            .cornerRadius(8)
            .accessibilityShowsLargeContentViewer {
                Text(model.getValueTextForLargeContentViewer())
            }
            .scaleEffect(justMerged ? 1.1 : 1)
            .animation(.easeInOut(duration: 0.05), value: justMerged)
            .onReceive(model.$isMerged) { isMerged in
                if isMerged {
                    justMerged = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        justMerged = false
                    }
                }
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
