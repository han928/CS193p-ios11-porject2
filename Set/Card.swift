//
//  Card.swift
//  Set
//
//  Created by Han Lai on 12/1/17.
//  Copyright © 2017 Han Lai. All rights reserved.
//

import Foundation

struct Card: Equatable{
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (lhs.cardShading == rhs.cardShading) && (lhs.cardNumber == rhs.cardNumber) && (lhs.cardSymbol == rhs.cardSymbol) && (lhs.cardColor == rhs.cardColor)
    }
    
    let cardShading: Int
    let cardNumber: Int
    let cardSymbol: Int
    let cardColor: Int
    
    
    init(_ shading: Int, _ number: Int, _ symbol: Int, _ color: Int) {
        self.cardShading = shading
        self.cardNumber = number
        self.cardSymbol = symbol
        self.cardColor = color
        
    }
}
