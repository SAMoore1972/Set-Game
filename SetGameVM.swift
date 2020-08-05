//
//  SetGameVM.swift
//  Set Game
//
//  Created by Simon Moore on 30/07/2020.
//  Copyright © 2020 Simon Moore. All rights reserved.
//

import SwiftUI

class SetGameVM: ObservableObject {
    @Published private var setGame: SetGame

    init() {
        setGame = SetGame()
    }
    
    // MARK: - SetGameVM Constants
    
    private let ANIMATION_DURATION: Double = 1.0
    
    // MARK: - Access to model
    
    var cards: Array<SetGame.Card> { setGame.cards }
    
    var cardsInPlay: Array<SetGame.Card> { setGame.cards.filter { $0.status != SetGame.Status.inDeck } }
    
    // MARK: - Intents
    
    func choose(card: SetGame.Card)
    {
        setGame.choose(card: card)
    }
    
    func deal() {
        setGame.deal3NewCards()
    }
    
    func canDeal() -> Bool {
        return setGame.cards.count > setGame.numberOfCardsWithout(SetGame.Status.inDeck)
    }
    
    func newGame() {
        setGame = SetGame()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + ANIMATION_DURATION) {
            withAnimation(.spring()) {
                self.setGame.startGame()
            }
        }
    }
    
    func startGame() {
        setGame.startGame()
    }
}
