//
//  CellModel.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import Combine
import SwiftUI

class CellModel: ObservableObject {
    
    init(id: Int) {
        self.id = id
    }
    
    let id: Int
    @Published var value: Int = 0
    @Published var isMerged: Bool = false
    @Published var newlyAdded: Bool = false
    
    func getValueText() -> String {
        guard value > 0 else {
            return ""
        }
        return "\(value)"
    }
    
    func getValueTextForLargeContentViewer() -> String {
        guard value > 0 else {
            return String(localized: "empty_cell")
        }
        return "\(value)"
    }
    
    func getBackgroundColor() -> Color {
        if value == 0 {
            return .clear
        } else if value < 8 {
            return .cellBackgroundLower
        } else if value == 8 {
            return .cellBackground8
        } else if value == 16 {
            return .cellBackground16
        } else if value == 32 {
            return .cellBackground32
        } else if value == 64 {
            return .cellBackground64
        } else if value == 128 {
            return .cellBackground128
        } else if value == 256 {
            return .cellBackground256
        } else if value == 512 {
            return .cellBackground512
        } else if value == 1024 {
            return .cellBackground1024
        } else if value == 2048 {
            return .cellBackground2048
        } else {
            return .cellBackgroundHigher
        }
    }
    
    func resetCell() {
        value = 0
        isMerged = false
    }
}
