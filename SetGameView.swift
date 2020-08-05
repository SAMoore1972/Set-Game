//
//  SetGameView.swift
//  Set Game
//
//  Created by Simon Moore on 30/07/2020.
//  Copyright © 2020 Simon Moore. All rights reserved.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var setGame: SetGameVM
    
    var body: some View {
        VStack {
            Grid(Array(setGame.cardsInPlay)) { cardInPlay in
                CardView(card: cardInPlay)
                    .onTapGesture {
                        self.setGame.choose(card: cardInPlay)
                }
                .zIndex(cardInPlay.status == SetGame.Status.matched ? 1.0 : 0.0)
                .padding(self.CARD_PADDING)
            }
            
            HStack {
                if setGame.canDeal() {
                    buttonView("Deal 3 More Cards", Color.blue) {
                        withAnimation {
                            self.setGame.deal()
                        }
                    }
                }
                
                buttonView("New Game", Color.pink) {
                    withAnimation {
                        self.setGame.newGame()
                    }
                }
            }
        }
        .onAppear {
            withAnimation {
                self.setGame.startGame()
            }
        }
        .padding()
        .background(Color.green)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func buttonView(_ text: String, _ color: Color, action: @escaping () -> Void ) -> some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(.white)
                .padding(BUTTON_PADDING)
                .background(color)
                .cornerRadius(BUTTON_CORNER_RADIUS)
        }
    }
    
    // MARK: SetGameView Constants
    private let BUTTON_PADDING: CGFloat = 10
    private let BUTTON_CORNER_RADIUS: CGFloat = 20
    private let CARD_PADDING: CGFloat = 5
}
