//
//  PlayData.swift
//  Project39
//
//  Created by Tanner Quesenberry on 2/20/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import Foundation

class PlayData {
    var allWords = [String]()
    //Items can only be added once but keeps track of # of times trying to add or remove item
    var wordCounts: NSCountedSet!
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                //split string by anything not a letter or number
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                allWords = allWords.filter { $0 != "" }
                
                //Create counted set
                wordCounts = NSCountedSet(array: allWords)
                //$0 is first word in comparison. Return true ("sort before") if count of first word greater than second
                let sorted = wordCounts.allObjects.sorted { wordCounts.count(for: $0) > wordCounts.count(for: $1)}
                allWords = sorted as! [String]
            }
        }
    }
}
