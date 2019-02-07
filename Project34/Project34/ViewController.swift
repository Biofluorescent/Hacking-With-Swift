//
//  ViewController.swift
//  Project34
//
//  Created by Tanner Quesenberry on 2/6/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import GameplayKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet var columnButtons: [UIButton]!
    var board: Board!
    var placedChips = [[UIView]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }
        
        resetBoard()
    }

    //Use tag of button pressed to place chip if able
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            continueGame()
        }
        
    }
    
    
    func resetBoard() {
        board = Board()
        updateUI()
        
        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }
            
            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    //Matches board's add(chip:in) method
    func addChip(inColumn column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column]
        //Calculate size of chip
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)
        
        //Create UIView with correct color and position
        if (placedChips[column].count < row + 1) {
            let newChip = UIView()
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = color
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })
            
            //Add chip to array
            placedChips[column].append(newChip)
        }
    }
    
    //Where chip should be placed
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        // Correct column button
        let button = columnButtons[column]
        //Set chip size
        let size = min(button.frame.width, button.frame.height / 6)
        
        //Horiztonal center for x position
        let xOffset = button.frame.midX
        //Botton of column button then subtract half chip size to get chip center
        var yOffset = button.frame.maxY - size / 2
        //How far to offset new chip vertically
        yOffset -= size * CGFloat(row)
        //Return point for chip center
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    
    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
    }
    
    
    //Called after every move, ends game if needed
    func continueGame() {
        //1. Optional game over string
        var gameOverTitle: String? = nil
        
        //2. Update string if draw or winner
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }
        
        //3. If game over, show alert and reset board
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
                self.resetBoard()
            }
            
            alert.addAction(alertAction)
            present(alert, animated: true)
            
            return
        }
        
        //4. Otherwise change players
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
    }
}

