//
//  Card.swift
//  Set
//
//  Created by Han Lai on 12/1/17.
//  Copyright © 2017 Han Lai. All rights reserved.
//

import Foundation

struct Card: Equatable, CustomStringConvertible{
    var description: String {
        return "\(symbol) \(number) \(symbol) \(color)"
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (lhs.shading.rawValue == rhs.shading.rawValue) && (lhs.number == rhs.number) && (lhs.symbol == rhs.symbol) && (lhs.color == rhs.color)
    }
    
    var shading: Shading
    var number: Number
    var symbol: Symbol
    var color: Color
    
    enum Symbol: String, CustomStringConvertible {
        var description: String {
            return self.rawValue
        }

        case oval
        case squiggle
        case diamond
        static var all = [Symbol.oval, .squiggle, .diamond]
        
    }
    
    enum Shading: String, CustomStringConvertible{
        var description: String {
            return "\(self.rawValue)"
        }
        
        case solid
        case striped
        case open
        
        static var all = [Shading.solid, Shading.striped, Shading.open]
    }
    
    enum Color: String, CustomStringConvertible {
        var description: String {
            return "\(self.rawValue)"
        }
        case red
        case green
        case purple
        static var all = [Color.red, .green, .purple]
    }
    
    enum Number: Int, CustomStringConvertible{
        var description: String {
            return "\(self.rawValue)"
        }

        case one = 1
        case two = 2
        case three = 3
        static var all = [Number.one, .two, .three]
        
    }
    
}
