//
//  ViewController.swift
//  Set
//
//  Created by Han Lai on 11/30/17.
//  Copyright © 2017 Han Lai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // start SetGame instance
    private lazy var game = SetGame()
    
    override func viewDidLoad() {
        setupNewGame()
    }
    
    @IBOutlet weak var dealtCardButton: UIButton!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            
            print("touched cards no. \(cardNumber)")
            print(game.cardsDeck[buttonToCard[cardNumber]!].cardShading,game.cardsDeck[buttonToCard[cardNumber]!].cardNumber,game.cardsDeck[buttonToCard[cardNumber]!].cardSymbol,
                  game.cardsDeck[buttonToCard[cardNumber]!].cardColor)
            
            checkMatch()
            highlightCards(sender: sender)
            _ = dealt3CardsDisabler()
            updateViewFromModel()
            
        } else {
            print("can't find cards in cardButtons")
        }
    }
    
    @IBAction func touchNewGame() {
        print("touch new game button")
        
        setupNewGame()
    }
    
    private func setupNewGame() {
        game = SetGame()
        selectedCards = [Int]()
        buttonToCard = [Int:Int]()
        cardToButton = [Int:Int]()
        dealtCardButton.isEnabled = true
        updateViewFromModel()

    }
    
    @IBAction func dealCards() {
        
        // CheckMatch first
        checkMatch()
        
        // Check number of cards to be dealt --> deal 3 more button would be disabled already
        let dealMore = dealt3CardsDisabler()
        
        if dealMore {
            // Update Model and dealt cards
            game.dealtCard()
            
            // update views
            updateViewFromModel()

        }
        
        _ = dealt3CardsDisabler()
    }
    

    
    // Controller coordination with model with these 4 dictionary
    private var shadingStrokesDict = [0: -1, 1: -1, 2: 5]
    private var shadingAlphaValue:[Int: Float] = [0: 1.0, 1: 0.15, 2: 1.0 ]
    private var colorDict = [0: UIColor.red, 1: UIColor.blue, 2: UIColor.green]
    private var symbolDict = [0: "◼︎", 1: "▲", 2: "●"]
    
    // array to track selected cards, do nothing until selectedCards has 3 items, then reset
    private var selectedCards = [Int]()
    
    // recording which button goes to which card now
    private var buttonToCard = [Int:Int]()
    private var cardToButton = [Int:Int]()
    
    
    private func setCardView(card: Card, button: UIButton ) {
        let attribute:[NSAttributedStringKey: Any] = [
            .strokeWidth: shadingStrokesDict[card.cardShading]!,
            .strokeColor: colorDict[card.cardColor]!,
            .foregroundColor: colorDict[card.cardColor]!.withAlphaComponent(CGFloat(shadingAlphaValue[card.cardShading]!))            
        ]
        
        // set n symbol
        let buttonText = String(repeating: symbolDict[card.cardSymbol]!, count: (card.cardNumber+1) )
        
        
        let attributedString = NSAttributedString(string: buttonText, attributes: attribute)
        button.setAttributedTitle(attributedString, for: UIControlState.normal)
        button.isHidden = false
        

    }
    
    private func dealt3CardsDisabler() -> Bool {
        let excessButton = cardButtons.count - buttonToCard.count
        let excessCards = game.cardsDeck.count - (game.dealtCards.count + game.removedCards.count)
        
        let dealMore = excessButton > 0 && excessCards > 0
        
        if  !dealMore {
            dealtCardButton.isEnabled = false
        } else {
            dealtCardButton.isEnabled = true
        }
        
        return dealMore
        
    }
    
    private func updateViewFromModel(){
        // hide all cards
        for idx in 0..<cardButtons.count {
            cardButtons[idx].isHidden = true
            
        }

        
        for card in game.dealtCards {
            let cardGameIndex = game.cardsDeck.index(of: card)!
            
            if cardToButton[cardGameIndex] == nil {
                for (index, button) in cardButtons.enumerated() {
                    
                    // find empty buttons
                    if button.isHidden {
                        
                        cardToButton[cardGameIndex] = index
                        buttonToCard[index] = cardGameIndex
                        break
                    }
                }
                
                if cardToButton[cardGameIndex] == nil {
                    print ("dealtCards has more than 24 cards")
                }
                
            }
            
            // if cards already assign to a button
            setCardView(card: card, button: cardButtons[cardToButton[cardGameIndex]!])

            
        }
        
        
    }
    
    
    
    /*
     highlight cards and determine if cards been selected
    */
    private func highlightCards(sender button: UIButton) {
        // check if the cards has alread been highlighted
        if !selectedCards.contains(cardButtons.index(of: button)!) {
            selectedCards.append(cardButtons.index(of: button)!)
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.blue.cgColor

        } else {
            
            selectedCards = selectedCards.filter {$0 != cardButtons.index(of: button)!}
            
            reverseHighlightCards(sender: button)
        }
        
    }
    
    /*
     remove highlight on the cards
    */
    func reverseHighlightCards(sender button: UIButton) {
        button.layer.borderWidth = 0
    }

    
    /*
     check match
     */
  
    private func checkMatch() {
        if selectedCards.count == 3 {
            // determine if there's match
            let isMatched = game.checkMatch(
                card1: game.cardsDeck[buttonToCard[selectedCards[0]]!],
                card2: game.cardsDeck[buttonToCard[selectedCards[1]]!],
                card3: game.cardsDeck[buttonToCard[selectedCards[2]]!])
            
            
            // de-select the cards
            for idx in selectedCards {
                reverseHighlightCards(sender: cardButtons[idx])
                
                if isMatched {
                    // hide the button if there's match
                    cardButtons[idx].isHidden = true
                    
                    // move the cards to removedCards
               
                    let removedCard = game.dealtCards.remove(at: game.dealtCards.index(of: game.cardsDeck[buttonToCard[idx]!])!)
                    
                    
                    
                   game.removedCards.append(removedCard)
                    
                    // set the reference to none
                    let tmpCardIndex = buttonToCard[idx]!
                    buttonToCard[idx] = nil
                    cardToButton[tmpCardIndex] = nil
                    
                }
            }

            print ("isMatched's value is \(isMatched)")
            
            // reset selectedCards to no selection
            selectedCards = []
            
            
        }

    }
    
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
            
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(abs(self))))
            
        } else {
            return 0
        }
    }

}

extension Array {
    mutating func shuffle() {
        if self.count > 0 {
            
            for idx in 0..<(self.count-2 ){
                let randNum = idx + Int(arc4random_uniform(UInt32(self.count-idx)))
                self.swapAt(idx, randNum)

            }
            
        }
    }
}

