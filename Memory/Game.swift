//
//  Game.swift
//  Memory
//
//  Created by Marie-Noëlle  on 29/01/2020.
//  Copyright © 2020 Marie-Noëlle . All rights reserved.
//

import Foundation

class Game {
        
    var cards: [Int]

    var totalScore = 0
    
    var currentScore: Int { winningCards.count }
        
    var winningCards = [Int]()
        
    var isWon = false
    

    init() {
        cards = (0...31).map { $0 % 16 + 1 }
     }
    
    func initialize() {
        cards.shuffle()
        winningCards = []
        isWon = false
    }
    
    func flipCards(_ cardOne: Int, _ cardTwo: Int) -> Bool {
        if cardOne == cardTwo {
            winningCards += [cardOne, cardTwo]
            
            totalScore += winningCards.suffix(2).count
            
            if winningCards.count == cards.count { isWon = true }
                        
            return true
        }
        
        return false
    }

}
