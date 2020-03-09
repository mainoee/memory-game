//
//  ViewController.swift
//  Memory
//
//  Created by Marie-Noëlle  on 23/01/2020.
//  Copyright © 2020 Marie-Noëlle . All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
        
    @IBOutlet var timerLabel: UILabel!
    
    @IBOutlet var totalScoreLabel: UILabel!
                            
    let game = Game()
                        
    var timer: Timer?

    var timeLeft: Float = 90 * 10
    
    var selectedIndexPaths = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isUserInteractionEnabled = false
                        
        setUpGame()
    }
    
    
    func setUpGame() {
        game.initialize()
        timerLabel.textColor = UIColor.black
        timerLabel.text = "Press START to play"
        totalScoreLabel.text = "\(game.totalScore) points"
    }
    
    func startNewGame() {
        collectionView.reloadData()
        
        timeLeft = 90 * 10
        selectedIndexPaths = []
        
        setUpGame()
    }
    
    @IBAction func startButtonTapped() {
        collectionView.isUserInteractionEnabled = true
        runTimer()
    }
    
    func runTimer() {
      if timer == nil {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
      }
    }

    @objc func updateTimer() {
        timeLeft -= 1
        timerLabel.text = "Time remaining: \(timeLeft/10)s"

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil

            timerLabel.textColor = UIColor.red

            checkGameResult()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCell else {
            fatalError("Unable to dequeue CardCell")
        }
        
        cell.isUserInteractionEnabled = true
        
        let card = game.cards[indexPath.row]
        
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else {
            fatalError("Unable to select CardCell")
        }
                
        cell.flipCard()
        
        cell.isUserInteractionEnabled = false
        
        selectedIndexPaths.append(indexPath)
   
        if selectedIndexPaths.count == 2 {
            let cardOne = game.cards[selectedIndexPaths[0].row]
            let cardTwo = game.cards[indexPath.row]

            let match = game.flipCards(cardOne, cardTwo)
            didMatch(match)
        }
    }
    
    func didMatch(_ match: Bool) {
        let cellOne = collectionView.cellForItem(at: selectedIndexPaths[0]) as! CardCell
        let cellTwo = collectionView.cellForItem(at: selectedIndexPaths[1]) as! CardCell

        if match {
            cellOne.remove()
            cellTwo.remove()
            
            checkGameResult()
            
        } else {
            cellOne.flipBackCard()
            cellTwo.flipBackCard()

            cellOne.isUserInteractionEnabled = true
            cellTwo.isUserInteractionEnabled = true
        }

        selectedIndexPaths.removeAll()
    }
    
    func checkGameResult() {
        var title = ""
        var message = ""
        
        if game.isWon {
            if timeLeft > 0 {
                timer?.invalidate()
                timer = nil
            }
                        
            title = "Congrats!"
            message = "You've smashed the game: \(game.currentScore) points!"
            
            
        } else {
            if timeLeft > 0 { return }
            
            title = "Game over!"
            message = "\(game.currentScore) points - \(game.cards.count - game.winningCards.count) cards left"
        }
        
        showAlert(title, message)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Play again", style: .default, handler:  {
            action in
            self.startNewGame()
        })
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
        collectionView.isUserInteractionEnabled = false
    }
}
