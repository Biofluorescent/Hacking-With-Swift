//
//  Project39Tests.swift
//  Project39Tests
//
//  Created by Tanner Quesenberry on 2/20/19.
//  Copyright © 2019 Tanner Quesenberry. All rights reserved.
//

import XCTest
@testable import Project39

class Project39Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAllWordsLoaded() {
        let playData = PlayData()
        XCTAssertEqual(playData.allWords.count, 18440, "allWords must be 18440")
    }

    func testWordCountsAreCorrect() {
        let playData = PlayData()
        XCTAssertEqual(playData.wordCounts.count(for: "Master"), 225, "Master does not appear 225 times")
        XCTAssertEqual(playData.wordCounts.count(for: "recover"), 16, "recover does not appear 16 times")
        XCTAssertEqual(playData.wordCounts.count(for: "tis"), 380, "tis does not appear 380 times")
    }
    
    func testWordsLoadQuickly() {
        //Runs 10 times, get report on how long the call took on average
        measure {
            _ = PlayData()
        }
    }
    
    func testUserFilterWorks() {
        let playData = PlayData()
        
        playData.applyUserFilter("100")
        XCTAssertEqual(playData.filteredWords.count, 495)
        
        playData.applyUserFilter("1000")
        XCTAssertEqual(playData.filteredWords.count, 55)
        
        playData.applyUserFilter("10000")
        XCTAssertEqual(playData.filteredWords.count, 1)
        
        playData.applyUserFilter("test")
        XCTAssertEqual(playData.filteredWords.count, 56)
        
        playData.applyUserFilter("swift")
        XCTAssertEqual(playData.filteredWords.count, 7)
        
        playData.applyUserFilter("objective-c")
        XCTAssertEqual(playData.filteredWords.count, 0)
    }
    
    
}
