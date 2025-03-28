//
//  WinMessageView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct WinMessageView: View {
    let restartAction: () -> Void
    let continueAction: () -> Void
    var body: some View {
        VStack {
            Text("you_won")
                .font(.largeTitle)
                .foregroundStyle(.accent)

            HStack {

                Button(action: {
                    continueAction()
                }) {
                    Text("continue_playing")
                        .font(.headline)
                        .padding()
                        .background(.buttonBackground)
                        .cornerRadius(8)
                }
                
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

            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.boardLines.opacity(0.7))
        .cornerRadius(8)
        .padding()
    }
}

#Preview {
    WinMessageView(restartAction: {
        print("restart tapped")
    }) {
        print("continue tapped")
    }
}
