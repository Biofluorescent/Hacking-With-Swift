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
    
    var strategist: GKMinmaxStrategist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 8
        //For tiebreakers. Set to nil returns first best move.
        //Could do randomly with: GKARC4RandomSource()
        strategist.randomSource = nil

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
    
    //MARK: - AI methods
    
    //AI determines what move it will make. To be called on background thread
    func columnForAIMove() -> Int? {
        if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }
        
        return nil
    }
    
    //AI makes moves. To be called on background thread
    func makeAIMove(in column: Int) {
        //Enable user interaction, Stop AI "think" spinner
        columnButtons.forEach { $0.isEnabled = true }
        navigationItem.leftBarButtonItem = nil
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            
            continueGame()
        }
    }
    
    //Run AI move in background with 1sec delay
    func startAIMove() {
        //Disable player while AI "thinks"
        columnButtons.forEach { $0.isEnabled = false }
        //Let user know AI in progress
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
        
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self.columnForAIMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let aiTimeCeiling = 1.0
            let delay = aiTimeCeiling - delta
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                self.makeAIMove(in: column)
            })
        }
    }
    
    //MARK: - Board UI methods
    
    func resetBoard() {
        board = Board()
        //Feed new board to strategist so it stands ready to look for moves.
        strategist.gameModel = board
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
        
        if board.currentPlayer.chip == .black {
            startAIMove()
        }
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

