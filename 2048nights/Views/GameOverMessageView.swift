//
//  GameOverMessageView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct GameOverMessageView: View {
    let restartAction: () -> Void
    var body: some View {
        VStack() {
           Text("game_over")
                .font(.largeTitle)
                .foregroundStyle(.accent)
            
            Button(action: {
                restartAction()
            }) {
                Text("try_again")
                    .font(.headline)
                    .padding()
                    .background(.buttonBackground)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.boardLines.opacity(0.7))
        .cornerRadius(8)
        .padding()
    }
}

#Preview {
    GameOverMessageView(restartAction: { print("Restarted") })
}
