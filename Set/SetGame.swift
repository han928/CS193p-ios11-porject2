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
    
    func equalOrAllDifferentString(att1: String, att2: String, att3: String) -> Bool {
        return (att1 == att2 && att1 == att3 && att2 == att3) || (att1 != att2 && att1 != att3 && att2 != att3)
    }


    func checkMatch (card1: Card, card2: Card, card3: Card) -> Bool {
        return  equalOrAllDifferentString(att1: card1.symbol.rawValue, att2: card2.symbol.rawValue, att3: card3.symbol.rawValue) && equalOrAllDifferentString(att1: card1.color.rawValue, att2: card2.color.rawValue, att3: card3.color.rawValue) && equalOrAllDifferent(att1: card1.number.rawValue, att2: card2.number.rawValue, att3: card3.number.rawValue) && equalOrAllDifferentString(att1: card1.shading.rawValue, att2: card2.shading.rawValue, att3: card3.shading.rawValue)
    }


    
    func dealtCard() {
        // double check there's more card to be dealt
        if (cardsDeck.count - (dealtCards.count + removedCards.count)) > 0{
            dealtCards += cardsDeck[deckIdentifier..<(deckIdentifier+3)]
            deckIdentifier += 3
        }
    }
    
    init() {
        
        for color in Card.Color.all {
            for number in Card.Number.all {
                for symbol in Card.Symbol.all {
                    for shading in Card.Shading.all {
                        cardsDeck.append(Card(shading: shading, number: number, symbol: symbol, color: color))
                    }
                }
            }
        }
        
        
        cardsDeck.shuffle()
        dealtCards = Array(cardsDeck[..<12])
        deckIdentifier = 12
        
    }
    
    
}

