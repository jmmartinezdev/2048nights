//
//  ArrowButtonsView.swift
//  2048nights
//
//  Created by Chema Martinez on 28/3/25.
//

import SwiftUI

struct ArrowButtonsView: View {
    let move: (MoveDirection) -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                move(.up)
            }, label: {
                Text("⬆")
                    .frame(width: 50, height: 50)
                    .background(.gray)
            })
            HStack {
                Button(action: {
                    move(.left)
                }, label: {
                    Text("⬅")
                        .frame(width: 50, height: 50)
                        .background(.gray)
                })
                Spacer()
                    .frame(width: 50, height: 50)
                Button(action: {
                    move(.right)
                }, label: {
                    Text("➡")
                        .frame(width: 50, height: 50)
                        .background(.gray)
                })
            }
            Button(action: {
                move(.down)
            }, label: {
                Text("⬇")
                    .frame(width: 50, height: 50)
                    .background(.gray)
            })
        }
    }
}
