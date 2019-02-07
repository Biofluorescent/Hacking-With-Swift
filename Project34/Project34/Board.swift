//
//  Board.swift
//  Project34
//
//  Created by Tanner Quesenberry on 2/6/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit
import GameplayKit

enum ChipColor: Int {
    case none = 0
    case red
    case black
}

class Board: NSObject {

    static var width = 7
    static var height = 6
    //1D array faster than using 2D
    var slots = [ChipColor]()
    
    var currentPlayer: Player
    
    override init() {
        currentPlayer = Player.allPlayers[0]
        
        for _ in 0 ..< Board.width * Board.height {
            slots.append(.none)
        }
        
        super.init()
    }
    
    //Read chip color in specific slot
    func chip(inColumn column: Int, row: Int) -> ChipColor {
        return slots[row + column * Board.height]
    }
    
    //Set chip color at specific slot
    func set(chip: ChipColor, in column: Int, row: Int){
        slots[row + column * Board.height] = chip
    }
    
    //Helper method: Return first empty row in the column, nil if full
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0 ..< Board.height {
            if chip(inColumn: column, row: row ) == .none {
                return row
            }
        }
        
        return nil
    }
    
    //Determine if player can play in a column
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    //Add chip to board
    func add(chip: ChipColor, in column: Int){
        if let row = nextEmptySlot(in: column){
            set(chip: chip, in: column, row: row)
        }
    }
    
    
    func isFull() -> Bool {
        for column in 0 ..< Board.width {
            if canMove(in: column) {
                return false
            }
        }
        
        return true
    }
    
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        let chip = (player as! Player).chip
        
        for row in 0 ..< Board.height {
            for col in 0 ..< Board.width {
                if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 0) {
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 0, moveY: 1) {
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 1) {
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: -1) {
                    return true
                }
            }
        }
        
        return false
    }
    
    
    func squaresMatch(initialChip: ChipColor, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
        //bail out early if we can't win from here
        if row + (moveY * 3) < 0 { return false }
        if row + (moveY * 3) >= Board.height { return false }
        if col + (moveX * 3) < 0 { return false }
        if col + (moveX * 3) >= Board.width { return false }
        
        //Check squares
        if chip(inColumn: col, row: row) != initialChip { return false }
        if chip(inColumn: col + moveX, row: row + moveY) != initialChip { return false }
        if chip(inColumn: col + (moveX * 2), row: row + (moveY * 2)) != initialChip { return false }
        if chip(inColumn: col + (moveX * 3), row: row + (moveY * 3)) != initialChip { return false }
        
        return true
    }
}
