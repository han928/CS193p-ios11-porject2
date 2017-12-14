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
    // initialize the grid with initial dealtCards
    private lazy var grid = refreshGrid()

    override func viewDidLoad() {
        setupNewGame()
        updateViewFromModel()
        
    }
    
    @IBAction func selectCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended, .changed:
            if let buttonNumber = getCardTouched(from: sender.location(in: cardViewCollections)){
    
                print("touched cards no. \(buttonNumber)")
    
                checkMatch(buttonNumber: buttonNumber)
                highlightCards(buttonNumber: buttonNumber)
                _ = dealt3CardsDisabler()
                updateViewFromModel()
    
            } else {
                print("can't find cards in cardButtons")
                }
        default:
            print("not ended")
        }
    }
    
    @IBOutlet weak var cardViewCollections: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealCards))
            swipe.direction = .down
            cardViewCollections.addGestureRecognizer(swipe)
            
            let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(sender:)))
            
            cardViewCollections.addGestureRecognizer(rotation)
        }
    }
    

    @objc private func shuffleCards(sender rocognizer: UIRotationGestureRecognizer) {
        switch rocognizer.state {
        case .ended:
                game.dealtCards.shuffle()
                updateViewFromModel()
        default:
                break
        }
    }
    @IBOutlet weak var dealtCardButton: UIButton!
    
    
    
    @IBAction func touchNewGame() {
        setupNewGame()
    }
    
    private func getCardTouched(from point: CGPoint) -> Int? {
        for idx in 0..<grid.cellCount{
            if let rect = grid[idx] {
                if rect.contains(point) {
                    return idx
                }
            }
            
        }
        return nil
    }
    
    private func refreshGrid() -> Grid{
        let nSideCount = Int(ceil(Float(game.dealtCards.count).squareRoot()))

        grid = Grid(layout: Grid.Layout.dimensions(rowCount: Int(nSideCount), columnCount: nSideCount), frame: cardViewCollections.bounds.insetBy(dx: 10, dy: 10))
        
        return grid
    }

    private func setCardView(card: Card, indexOf subView: Int ) {
        let newRect = grid[subView]!
        let cardView = CardView(frame: newRect.insetBy(dx: newRect.size.width/15, dy: newRect.size.width/15))
        
        cardView.color = card.color.rawValue
        cardView.number = card.number.rawValue
        cardView.symbol = card.symbol.rawValue
        cardView.shading = card.shading.rawValue
        cardView.isOpaque = false
        
        if selectedCards.contains(game.cardsDeck.index(of: card)!) {
            cardView.isSelected = true
        }
        cardViewCollections.addSubview(cardView)
        cardViewArray.append(cardView)
    }

    private func updateViewFromModel() {
        // refresh the grid size
        grid = refreshGrid()
        
        // hide all cards
        cardViewCollections.subviews.forEach({ $0.removeFromSuperview()})
        
        // refresh cardToButton and buttonToCard
        buttonToCard = [Int:Int]()
        cardToButton = [Int:Int]()

        
        for (cardIndex, card) in game.dealtCards.enumerated() {
            let cardGameIndex = game.cardsDeck.index(of: card)!
            
            
            
            cardToButton[cardGameIndex] = cardIndex
            buttonToCard[cardIndex] = cardGameIndex
            
            setCardView(card: card, indexOf: cardIndex)
            
        }
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
        checkMatch(buttonNumber: nil)
        
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
    

    
    // array to track selected cards, do nothing until selectedCards has 3 items, then reset
    private var selectedCards = [Int]()
    
    // recording which button goes to which card now
    private var buttonToCard = [Int:Int]()
    private var cardToButton = [Int:Int]()
    
    // array to store cardViews
    private var cardViewArray = [CardView]()
    
    
    private func dealt3CardsDisabler() -> Bool {
        let excessCards = game.cardsDeck.count - (game.dealtCards.count + game.removedCards.count)
        
        let dealMore = excessCards > 0
        
        if  !dealMore {
            dealtCardButton.isEnabled = false
        } else {
            dealtCardButton.isEnabled = true
        }
        
        return dealMore
        
    }
    
    
    
    /*
     highlight cards and determine if cards been selected
    */
    private func highlightCards(buttonNumber: Int) {
        // check if the cards has alread been highlighted
        if buttonToCard[buttonNumber] != nil {
            if !selectedCards.contains(buttonToCard[buttonNumber]!) {
                selectedCards.append(buttonToCard[buttonNumber]!)
                
            } else {
                selectedCards = selectedCards.filter {$0 != buttonToCard[buttonNumber]!}
            }

        }

    }

    

    
    /*
     check match
     */
  
    private func checkMatch(buttonNumber: Int?) {
        if selectedCards.count == 3 {
            
            // determine if there's match
            let isMatched = game.checkMatch(
                card1: game.cardsDeck[selectedCards[0]],
                card2: game.cardsDeck[selectedCards[1]],
                card3: game.cardsDeck[selectedCards[2]])


            // de-select the cards
            for idx in selectedCards {

                if isMatched {

                    
                    // move the cards to removedCards
                    let removedCard = game.dealtCards.remove(at: game.dealtCards.index(of: game.cardsDeck[idx])!)



                   game.removedCards.append(removedCard)

//                    // set the reference to none
//                    let tmpCardIndex = buttonToCard[idx]!
//                    buttonToCard[idx] = nil
//                    cardToButton[tmpCardIndex] = nil

                }
            }

            print ("isMatched's value is \(isMatched)")

            // reset selectedCards to no selection
            selectedCards = []
            
            if buttonNumber != nil {
                let fourthCardNumber = buttonToCard[buttonNumber!]!
                selectedCards.append(fourthCardNumber)

            }

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

