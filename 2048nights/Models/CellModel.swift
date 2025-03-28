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
    var isMerged: Bool = false
    
    func getValueText() -> String {
        guard value > 0 else {
            return ""
        }
        return "\(value)"
    }
    
    func getColorForValue() -> Color {
        switch value {
        case 8:
            return Color.orange
        case 16:
            return Color.yellow
        case 32:
            return Color.red
        case 64:
            return Color.blue
        case 128:
            return Color.green
        case 256:
            return Color.indigo
        case 512:
            return Color.mint
        case 1024:
            return Color.pink
        case 2048:
            return Color.purple
        default:
            return Color.black
        }
    }
}
