//
//  Card.swift
//  Set
//
//  Created by Han Lai on 12/1/17.
//  Copyright © 2017 Han Lai. All rights reserved.
//

import Foundation

class Card{
    var cardShading: NSAttributedString
    var cardNumber: Int
    var cardSymbol: String
    var cardColor: String
    
    init(shading: NSAttributedString, number: Int, symbol: String, color: String) {
        cardShading = shading
        cardNumber = number
        cardSymbol = symbol
        cardColor = color
    }
}
