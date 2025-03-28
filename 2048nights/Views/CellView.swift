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
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(Color.white)
            .background(model.getColorForValue())
    }
}
