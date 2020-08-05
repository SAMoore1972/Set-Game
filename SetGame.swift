//
//  SetGame.swift
//  Set Game
//
//  Created by Simon Moore on 30/07/2020.
//  Copyright © 2020 Simon Moore. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var cards: Array<Card>
    
    private var matchInPlay = false
    
    struct Card: Identifiable {
        var id = UUID()             // A unique id to conform to 'Identifiable' protocol
        var contents: Array<Int>    // An array containing 4 Ints, representing the 3 possible states of each of the cards' 4 properties
        var status: Status          // Status of the card in the current game, inDeck, inPlay, selected or matched
    }
    
    enum Status {
        case inDeck
        case inPlay
        case selected
        case matched
    }
    
    init()
    {
        cards = Array<Card>()
        
        for propertyOne in 0..<3 {
            for propertyTwo in 0..<3 {
                for propertyThree in 0..<3 {
                    for propertyFour in 0..<3 {
                        cards.append(Card(contents: [propertyOne, propertyTwo, propertyThree, propertyFour], status: Status.inDeck))
                    }
                }
            }
        }
        
        cards.shuffle()
    }

    // To start game deal out first 12 cards
    
    mutating func startGame()
    {
        for index in 0..<12 {
            cards[index].status = Status.inPlay
        }
    }
    
    func numberOfCardsWith(_ cardStatus: Status) -> Int {
        var numberOfCards = 0
        
        for card in cards {
            if card.status == cardStatus {
                numberOfCards += 1
            }
        }
        
        return numberOfCards
    }
    
    func numberOfCardsWithout(_ cardStatus: Status) -> Int {
        var numberOfCards = 0
        
        for card in cards {
            if card.status != cardStatus {
                numberOfCards += 1
            }
        }
        
        return numberOfCards
    }

    mutating func choose(card: Card)
    {
        let chosenIndex = cards.firstIndex(matching: card)!
        
        // MARK: Game Logic
        //
        // If player clicks on a card that is selected, and total number of selected cards is fewer than 3, then deselect chosen card,
        // otherwise, if there are 3 selected cards, reset all selected cards, and select the card the player chose.
        //
        // If player clicks on a matched card, remove the matching cards from the game and deal 3 new cards.
        //
        // ...TBC
            
        switch cards[chosenIndex].status {

        case Status.selected:
            if numberOfCardsWith(Status.selected) < 3 { cards[chosenIndex].status = Status.inPlay }
            else {
                setSelectedCardsTo(Status.inPlay)
                cards[chosenIndex].status = Status.selected
            }
            
        case Status.matched:
            removeMatchingCardsAndDeal()
            
        case Status.inPlay:
            if (numberOfCardsWith(Status.selected) < 3), !matchInPlay {
                cards[chosenIndex].status = Status.selected
                if numberOfCardsWith(Status.selected) == 3, selectedCardsAllMatch() {
                    setSelectedCardsTo(Status.matched)
                    matchInPlay = true
                }
            } else {
                if !matchInPlay, !selectedCardsAllMatch() {
                    setSelectedCardsTo(Status.inPlay)
                    cards[chosenIndex].status = Status.selected
                } else {
                    cards[chosenIndex].status = Status.selected
                    removeMatchingCardsAndDeal()
                }
            }
            
        default:
            break
        }
    }
    
    mutating private func removeMatchingCardsAndDeal() {
        matchInPlay = false

        for _ in 0..<3 {
            removeFirstMatchingCardFromGame()
        }
        
        deal3NewCards()
    }
    
    mutating private func removeFirstMatchingCardFromGame()
    {
        for index in 0..<cards.count {
            if cards[index].status == Status.matched {
                cards.remove(at: index)
                break
            }
        }
    }
    
    mutating private func setSelectedCardsTo(_ state: Status)
    {
        for index in 0..<cards.count {
            if cards[index].status == Status.selected { cards[index].status = state }
        }
    }
    
    mutating func deal3NewCards()
    {
        var numberOfCardsDealt = 0
        
        for index in 0..<cards.count {
            if cards[index].status == Status.inDeck {
                cards[index].status = Status.inPlay
                numberOfCardsDealt += 1
            }
            
            if numberOfCardsDealt == 3 { break }
        }
    }
    
    // MARK: Set game card matching logic
    
    private func selectedCardsAllMatch() -> Bool {
        let selectedCards = cards.filter { $0.status == Status.selected }

        let match = propertiesThatMatch(for: selectedCards)
        let differ = propertiesThatDontMatch(for: selectedCards)
        
        return (match.0 || differ.0) && (match.1 || differ.1) && (match.2 || differ.2) && (match.3 || differ.3)
    }
    
    private func propertiesThatMatch(for cards: Array<Card>) -> (Bool, Bool, Bool, Bool) {
        ( match(for: cards, property: 0),
          match(for: cards, property: 1),
          match(for: cards, property: 2),
          match(for: cards, property: 3) )
    }
    
    private func match(for cards: Array<Card>, property index: Int) -> Bool {
        cards[0].contents[index] == cards[1].contents[index] &&
        cards[0].contents[index] == cards[2].contents[index] &&
        cards[1].contents[index] == cards[2].contents[index]
    }
    
    private func propertiesThatDontMatch(for cards: Array<Card>) -> (Bool, Bool, Bool, Bool) {
        ( mismatch(for: cards, property: 0),
          mismatch(for: cards, property: 1),
          mismatch(for: cards, property: 2),
          mismatch(for: cards, property: 3) )
    }
    
    private func mismatch(for cards: Array<Card>, property index: Int) -> Bool {
        cards[0].contents[index] != cards[1].contents[index] &&
        cards[0].contents[index] != cards[2].contents[index] &&
        cards[1].contents[index] != cards[2].contents[index]
    }
}
