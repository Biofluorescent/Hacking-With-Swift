//
//  Board.swift
//  Project34
//
//  Created by Tanner Quesenberry on 2/6/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import UIKit

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
    
    override init() {
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
    
    
}
