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
    var wordCounts = [String: Int]()
    
    init() {
        if let path = Bundle.main.path(forResource: "plays", ofType: "txt") {
            if let plays = try? String(contentsOfFile: path) {
                //split string by anything not a letter or number
                allWords = plays.components(separatedBy: CharacterSet.alphanumerics.inverted)
                allWords = allWords.filter { $0 != "" }
                
                for word in allWords {
                    if wordCounts[word] == nil {
                        wordCounts[word] = 1
                    } else {
                        wordCounts[word]! += 1
                    }
                }
                
                allWords = Array(wordCounts.keys)
            }
        }
    }
}
