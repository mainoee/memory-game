//
//  CardCell.swift
//  Memory
//
//  Created by Marie-Noëlle  on 23/01/2020.
//  Copyright © 2020 Marie-Noëlle . All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    @IBOutlet var backCard: UIImageView!
    
    @IBOutlet var frontCard: UIImageView!
        
    func setCard(_ card: Int) {
        self.layer.cornerRadius = 8

        frontCard.image = UIImage(named: "card\(card)")

        backCard.alpha = 1
        frontCard.alpha = 1
                
        UIView.transition(from: frontCard, to: backCard, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipCard() {
        UIView.transition(from: backCard, to: frontCard, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBackCard() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontCard, to: self.backCard, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func remove() {
        backCard.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: { self.frontCard.alpha = 0 }, completion: nil)
    }
}
