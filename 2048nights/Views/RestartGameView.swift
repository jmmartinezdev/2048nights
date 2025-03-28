//
//  RestartGameView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct RestartGameView: View {
    let restartAction: () -> Void
    var body: some View {
        HStack {
            Spacer()

            Button(action: {
                restartAction()
            }) {
                Text("restart_game")
                    .font(.headline)
                    .padding()
                    .background(.buttonBackground)
                    .cornerRadius(8)
            }
        }.padding()
    }
}

#Preview {
    RestartGameView(restartAction: { print("Restarted") })
}
