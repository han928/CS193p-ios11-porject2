//
//  SetGame.swift
//  Set
//
//  Created by Han Lai on 12/1/17.
//  Copyright © 2017 Han Lai. All rights reserved.
//

import Foundation

class SetGame {
    
    var cardsDeck = [Card]()
    var dealtCards = [Card]()
    var removedCards = [Card]()
    var deckIdentifier = 0
    
    
    func equalOrAllDifferent(att1: Int, att2: Int, att3: Int) -> Bool {
        return (att1 == att2 && att1 == att3 && att2 == att3) || (att1 != att2 && att1 != att3 && att2 != att3)
    }

    func checkMatch (card1: Card, card2: Card, card3: Card) -> Bool {
        return  equalOrAllDifferent(att1: card1.cardSymbol, att2: card2.cardSymbol, att3: card3.cardSymbol) && equalOrAllDifferent(att1: card1.cardColor, att2: card2.cardColor, att3: card3.cardColor) && equalOrAllDifferent(att1: card1.cardNumber, att2: card2.cardNumber, att3: card3.cardNumber) && equalOrAllDifferent(att1: card1.cardShading, att2: card2.cardShading, att3: card3.cardShading)
    }


    
    func dealtCard() {
        // double check there's more card to be dealt
        if (cardsDeck.count - (dealtCards.count + removedCards.count)) > 0{
            dealtCards += cardsDeck[deckIdentifier..<(deckIdentifier+3)]
            deckIdentifier += 3
        }
    }
    
    init() {
        
        // initializing the deck of cards
        for color in 0..<3{
            for number in 0..<3 {
                for symbol in 0..<3 {
                    for shading in 0..<3 {
                        cardsDeck.append(Card(shading, number, symbol, color))
                    }
                }
            }
        }
        
        
        // shuffle cards
//        for idx in 0..<(cardsDeck.count-2) {
//
//            let randNum = idx + Int(arc4random_uniform(UInt32(cardsDeck.count-idx)))
//            cardsDeck.swapAt(idx, randNum)
//
//        }
        cardsDeck.shuffle()
        dealtCards = Array(cardsDeck[..<12])
        deckIdentifier = 12
        
    }
    
    
}

